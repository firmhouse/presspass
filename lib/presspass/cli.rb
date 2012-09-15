require 'net/http'
require 'fileutils'
require 'optparse'

require 'presspass'

if ARGV.first == "new"
  app_name = ARGV[1]

  ARGV.shift(2)

  options = {:php => "/usr/bin/php-cgi"}

  OptionParser.new do |opts|
    opts.banner = "Usage: presspass new <app_name> [options]"

    opts.on("--php [OPTIONAL]", "Path to PHP CGI binary") do |php_path|
      options[:php] = php_path
    end
  end.parse!

  if Dir.exists?(app_name)
    puts "A directory with name #{app_name} already exists."
  else

    if !File.exists?("wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
      puts "Downloading wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz..."

      Net::HTTP.start('wordpress.org') do |http|
        resp = http.get("/wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
        open("/tmp/wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz", 'w') do |file|
          file.write(resp.body)
        end
      end
    end

    puts "wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz downloaded."

    filestamp = Time.now.to_i
    download_location = File.join('/tmp', "wordpress-#{PressPass::WORDPRESS_VERSION}.tar.gz")
    tmp_dir = "/tmp/wordpress-latest-#{filestamp}"

    Dir.mkdir(tmp_dir)
    `cd #{tmp_dir}; tar -xzf #{download_location}`

    FileUtils.mv("#{tmp_dir}/wordpress", app_name)
    FileUtils.rm_r(tmp_dir)
    FileUtils.rm(download_location)

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

use Rack::Legacy::Php, Dir.getwd, '#{options[:php]}'
use Rack::Legacy::Cgi, Dir.getwd
run Rack::File.new Dir.getwd
EOF

    puts "Adding config.ru for usage with Pow."
    
    File.open(File.join(app_name, "config.ru"), "w") do |file|
      file.write(config_ru)
    end

    puts "WordPress installation created at #{app_name}."
  end
end