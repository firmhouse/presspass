require 'erb'

module PressPass
  module Cli

    class NewProjectGenerator

      def initialize(app_name)
        @app_name = app_name
      end

      def run
        app_name = @app_name

        options = {:php => nil}

        OptionParser.new do |opts|
          opts.banner = "Usage: presspass new <app_name> [options]"

          opts.on("--php [OPTIONAL]", "Path to PHP CGI binary") do |php_path|
            options[:php] = php_path
          end
        end.parse!

        create_project_directory

        download_wordpress

        extract_wordpress_into_project_directory

        add_rack_config(:php_cgi_path => options[:php])

        puts "WordPress installation created at #{@app_name}."
      end

      private

      def create_project_directory
        if Dir.exists?(@app_name)
          puts "A directory with name #{@app_name} already exists."
          return
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

use Rack::Rewrite do
  rewrite %r{(.*/$)}, lambda {|match, rack_env|
    INDEXES.each do |index|
      if File.exists?(File.join(Dir.getwd, rack_env['PATH_INFO'], index))
        return rack_env['PATH_INFO'] + index
      end
    end
    rack_env['PATH_INFO']
  }
end

use Rack::Legacy::Php, Dir.getwd<% if options[:php_cgi_path] %>, '<%= options[:php_cgi_path] %>' <% end %>
use Rack::Legacy::Cgi, Dir.getwd
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