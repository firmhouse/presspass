$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'presspass/presspass'

Gem::Specification.new do |s|
  s.name = 'presspass'
  s.version = PressPass::VERSION
  s.date = Date.today
  s.summary = 'PressPass makes doing WordPress development awesome'
  s.author = 'Michiel Sikkes'
  s.email = 'michiel@firmhouse.com'
  s.files = ['lib/presspass.rb', 'lib/presspass/presspass.rb', 'lib/presspass/cli.rb', 'lib/presspass/cli/new_project_generator.rb', 'lib/presspass/cli/linker.rb']
  s.homepage = 'http://github.com/firmhouse/presspass'
  s.executables << 'presspass'
  s.license = 'MIT'

  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'rack-legacy'
  s.add_runtime_dependency 'rack-rewrite'

  s.description = <<-EOF
    PressPass is a command-line tool that helps you do WordPress development.

    It lets you install the latest WordPress version on your local development machine
    and sets it up for usage with PHP and Pow so you can run it along side your
    Rails apps if you want to.

    It contains generation tools similar to the rails command for generating themes
    and plugins.
  EOF

  s.post_install_message = <<-EOF
    Thank you for installing PressPass! Now get started with setting up a 
    WordPress installation in your current directory:

        presspass new my_blog

    If you need help, please create an issue at
      https://github.com/firmhouse/presspass/issues
      
  EOF
end