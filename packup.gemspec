$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'date'
require 'packup'

spec = Gem::Specification.new do |s|
  s.name = 'packup'
  s.version = Packup::VERSION
  s.date = Date.today.to_s

  s.summary = 'A Rake helper for building Windows installers'
  s.description = <<desc
  This gem helps you write Windows installers. It provides a
  simple DSL for authoring MSI packages.
desc

  s.authors = ['Frank Mitchell']
  s.email = 'me@frankmitchell.org'
  s.homepage = 'https://github.com/elimossinary/packup'

  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md]

  s.files = `git ls-files`.split("\n")
  s.files.reject! { |file| file =~ /^\./ }

  s.test_files = `git ls-files -- test/*_test.rb`.split("\n")
end
