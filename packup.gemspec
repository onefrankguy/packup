Gem::Specification.new do |s|
  # These will be modified by the rake gemspec task.
  s.name = 'packup'
  s.version = '0.0.1'
  s.date = '2012-05-24'

  # Don't remove the manifest lines. The gemspec
  # task uses them to parse the this file.
  # = MANIFEST =
  s.files = %w[
    README.md
    lib/packup.rb
    test/packup_test.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |file| file =~ /^test\/test_.*\.rb/ }
end
