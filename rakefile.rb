require 'rubygems'
require 'rake'
require 'date'

desc 'Generate .gemspec file'
task :gemspec do
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)

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

def date
  Date.today.to_s
end

def gemspec_file
  "#{name}.gemspec"
end

def replace_header head, header
  head.sub!(/(\.#{header}\s*= ').*'/) { "#{$1}#{send(header)}'" }
end
