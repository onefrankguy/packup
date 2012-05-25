$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'packup'

spec = Gem::Specification.new do |s|
  s.name = 'packup'
  s.version = Packup::VERSION

  s.summary = 'A Rake helper for building Windows installers'
  s.description = 'This gem provides a simple DSL for making MSI packages.'

  s.author = 'Frank Mitchell'
  s.email = 'me@frankmitchell.org'
  s.homepage = 'https://github.com/elimossinary/packup'

  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md]

  s.files = `git ls-files`.split("\n")
  s.files.reject! { |file| file =~ /^\./ }

  s.test_files = `git ls-files -- test/*_test.rb`.split("\n")
end
