$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'rexml/document'
require 'test/unit'

class PackupWxsTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
    FileUtils.remove_dir 'wix', true
  end

  def test_wxs_file_has_product_name
    Packup.stuff 'Magic'
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    product = REXML::XPath.first(wxs, "/Wix/Product")
    assert_equal 'Magic', product.attributes['Name']
  end

  def test_wxs_file_has_product_version
    Packup.stuff 'Magic' do
      version '1.0.0'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    product = REXML::XPath.first(wxs, "/Wix/Product")
    assert_equal '1.0.0', product.attributes['Version']
  end

  def test_wxs_file_has_product_manufacturer
    Packup.stuff 'Magic' do
      author 'Wizard'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    product = REXML::XPath.first(wxs, "/Wix/Product")
    assert_equal 'Wizard', product.attributes['Manufacturer']
  end
end
