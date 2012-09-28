require 'yaml'

module PressPass

  module Cli

    class Linker

      def self.run(arguments = nil)

        config_file = File.join(Dir.home, '.presspass.yml')

        config = {}

        File.open( config_file, "r+") do |file|
          config = YAML.load(file)
        end

        if config["installation_dir"].nil?
          puts <<-EOF

  You don't have a local PressPass-enabled WordPress installation yet.

  Install one using:

      presspass new <directory>

          EOF
          return
        end

        if arguments.empty?
          if directory_is_theme?(Dir.pwd)
            link(Dir.pwd, File.expand_path(config["installation_dir"]))
          end
        end

      end

      def self.directory_is_theme?(path)
        File.exists?(File.join(path, 'style.css'))
      end

      def self.link(theme_path, installation_path)

        link_path = File.join(installation_path, 'wp-content', 'themes', File.basename(theme_path))

        if File.symlink?(link_path)
          puts "Theme directory #{theme_path} is already linked in #{link_path}"
          return
        end

        puts "Linking #{theme_path} into #{link_path}"
        File.symlink(theme_path, link_path)

      end

    end

  end

end