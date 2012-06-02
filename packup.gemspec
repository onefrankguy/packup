$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'packup'

spec = Gem::Specification.new do |s|
  s.name = 'packup'
  s.version = Packup::VERSION
  s.required_ruby_version = '~> 1.9'

  s.summary = 'A Rake helper for building Windows installers'
  s.description = 'This gem provides a simple DSL for making MSI packages.'

  s.requirements << 'WiX Toolset, v3.6 or greater'
  s.add_runtime_dependency 'rake', '~> 0.9.2'

  s.author = 'Frank Mitchell'
  s.email = 'me@frankmitchell.org'
  s.homepage = 'https://github.com/elimossinary/packup'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.files.reject! { |file| file =~ /^\./ }

  s.test_files = `git ls-files -- test/*_test.rb`.split("\n")
end
