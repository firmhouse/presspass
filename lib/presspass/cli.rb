require 'net/http'
require 'fileutils'
require 'optparse'

require 'presspass'
require 'presspass/cli/new_project_generator'
require 'presspass/cli/linker'

if ARGV.first == "new"
  ARGV.shift

  if ARGV.first.nil?
    ARGV << "--help"
  end

  generator = PressPass::Cli::NewProjectGenerator.new
  generator.run
elsif ARGV.first == "init"
  ARGV.shift

  if ARGV.first.nil?
    ARGV << "--help"
  end

  generator = PressPass::Cli::NewProjectGenerator.new
  generator.init
elsif ARGV.first == "link"
  ARGV.shift

  PressPass::Cli::Linker.run(ARGV)
end