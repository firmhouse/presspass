require 'net/http'
require 'fileutils'
require 'optparse'

require 'presspass'
require 'presspass/cli/new_project_generator'

if ARGV.first == "new"
  app_name = ARGV[1]
  ARGV.shift(2)

  generator = PressPass::Cli::NewProjectGenerator.new(app_name)
  generator.run

end