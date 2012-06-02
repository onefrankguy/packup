require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/clean'

CLEAN.include '*.gem'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc 'Build the gem'
task :build do
  sh "gem build #{gemspec_file}"
end

desc 'Install the gem'
task :install do
  sh "gem install ./#{name}-#{version}.gem"
end

desc 'Uninstall the gem'
task :uninstall do
  sh "gem uninstall #{name}"
end

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def gemspec_file
  "#{name}.gemspec"
end
