require 'erb'
require 'open-uri'

module PressPass
  module Cli

    class NewProjectGenerator

      def initialize(command = "new")
        @options = {:php_port => 8000}

        @app_name = ARGV.first

        OptionParser.new do |opts|
          opts.banner = "Usage: presspass #{command} <app_name> [options]"

          opts.on("--port NUMBER", "Port to run PHP on") do |php_port|
            @options[:php_port] = php_port
          end

        end.parse!(ARGV)

      end

      def run
        create_project_directory

        download_wordpress

        extract_wordpress_into_project_directory

        install_foreman(php_port: @options[:php_port])

        puts "WordPress installation created at #{@app_name}."
        puts "You can now run:"
        puts
        puts "    $ gem install foreman"
        puts "    $ cd #{@app_name}/"
        puts "    $ foreman start"
        puts
        puts "And see your WordPress development environment live at http://localhost:8000!"
      end

      private

      def install_foreman(php_port: 8000)
        foreman_config = "web: php -S 0.0.0.0:#{php_port}\n"

        File.open(File.join(@app_name, "Procfile"), "w+") do |f|
          f.write(foreman_config)
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
          filename = "wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz"
          puts "Downloading #{filename}..."

          `curl -o /tmp/#{filename} https://wordpress.org/#{filename}`
        end

        puts "#{filename} downloaded."
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

    end
  end
end
