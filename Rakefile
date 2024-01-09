# frozen_string_literal: true

require "rake/clean"
require "rubygems/tasks"
require "rake/testtask"

gem_tasks = Gem::Tasks.new
Rake::TestTask.new
CLOBBER.include gem_tasks.build.gem.project.builds.values.collect(&:values).flatten

task default: :test
