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

desc 'Uninstall this gem'
task :uninstall do
  sh "gem uninstall #{name}"
end

desc 'Generate .gemspec file'
task :gemspec do
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  replace_header(head, :name)
  replace_header(head, :version)

  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg|wix)/ }.
    map { |file| "    #{file}" }.
    join("\n")

  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |io| io << spec }
  puts "Updated #{gemspec_file}"
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

def replace_header head, header
  head.sub!(/(\.#{header}\s*= ').*'/) { "#{$1}#{send(header)}'" }
end
