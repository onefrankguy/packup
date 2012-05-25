$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'rexml/document'
require 'test/unit'

class PackupTasksTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
  end

  def test_wxs_file_has_product_name
    Packup.stuff 'Magic'
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    product = REXML::XPath.first(wxs, "/Wix/Product")
    assert_equal 'Magic', product.attributes['Name']
  end
end
