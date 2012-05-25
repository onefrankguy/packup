$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'date'
require 'packup'

Gem::Specification.new do |s|
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

  # Don't remove the manifest lines. The gemspec
  # task uses them to parse the this file.
  # = MANIFEST =
  s.files = %w[
    README.md
    lib/packup.rb
    test/packup_test.rb
  ]
  # = MANIFEST =

  s.test_files = `git ls-files -- test/*_test.rb`.split("\n")
end
