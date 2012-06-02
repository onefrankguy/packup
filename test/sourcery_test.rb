$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'rexml/document'
require 'test/unit'

class PackupSourceryTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
    FileUtils.remove_dir 'wix', true
  end

  def test_sourcery_file_has_sources
    Packup.stuff 'Magic' do
      file 'README.md' => 'README.md'
    end
    Rake::Task['wix/Sourcery.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Sourcery.wxs')
    element = REXML::XPath.first(wxs, "//File")
    assert '$(var.Source)\README.md', element.attributes['Source']
  end
end
