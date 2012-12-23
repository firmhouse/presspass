require 'erb'

module PressPass
  module Cli

    class NewProjectGenerator

      def initialize(command = "new")
        @options = {:php => nil}

        @app_name = ARGV.first

        OptionParser.new do |opts|
          opts.banner = "Usage: presspass #{command} <app_name> [options]"

          opts.on("--php PATH", "Path to PHP CGI binary") do |php_path|
            @options[:php] = php_path
          end

        end.parse!(ARGV)

      end

      def run
        create_project_directory

        download_wordpress

        extract_wordpress_into_project_directory

        init

        puts "WordPress installation created at #{@app_name}."
      end

      def init
        add_rack_config(:php_cgi_path => @options[:php])

        set_default_config
      end

      private

      def set_default_config

        config_file = File.join(File.expand_path('~'), '.presspass.yml')

        config = {}
        config["installation_dir"] = File.expand_path(@app_name)

        File.open( config_file, "w+") do |file|
          file.write(YAML.dump(config))
        end

      end

      def create_project_directory
        if File.exist?(@app_name)
          puts "A file or directory with name #{@app_name} already exists."
          exit 1
        end
      end

      def download_wordpress
        if !File.exists?("/tmp/wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
          puts "Downloading wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz..."

          Net::HTTP.start('wordpress.org') do |http|
            resp = http.get("/wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
            open("/tmp/wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz", 'w') do |file|
              file.write(resp.body)
            end
          end
        end

        puts "wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz downloaded."
      end

      def extract_wordpress_into_project_directory
        filestamp = Time.now.to_i
        download_location = File.join('/tmp', "wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
        tmp_dir = "/tmp/wordpress-latest-#{filestamp}"

        Dir.mkdir(tmp_dir)
        `cd #{tmp_dir}; tar -xzf #{download_location}`

        FileUtils.mv("#{tmp_dir}/wordpress", @app_name)
        FileUtils.rm_r(tmp_dir)
      end

      def add_rack_config(opts = {})
        options = { :php_cgi_path => nil }
        options.merge!(opts)

        config_ru = <<EOF
require 'rack'
require 'rack-legacy'
require 'rack-rewrite'

INDEXES = ['index.html','index.php', 'index.cgi']

ENV['SERVER_PROTOCOL'] = "HTTP/1.1"

use Rack::Legacy::Php, Dir.getwd<% if options[:php_cgi_path] %>, '<%= options[:php_cgi_path] %>' <% end %>
run Rack::File.new Dir.getwd
EOF
        config_ru_template = ERB.new(config_ru)

        puts "Adding config.ru for usage with Pow."
    
        File.open(File.join(@app_name, "config.ru"), "w") do |file|
          file.write(config_ru_template.result(binding))
        end
      end
    end
  end
end