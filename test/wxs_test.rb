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

  def test_wxs_file_has_upgrade_code
    Packup.stuff 'Magic'
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    product = REXML::XPath.first wxs, '/Wix/Product'
    assert_equal '02700E45-4D67-9F31-F27C-6F0768986DD1', product.attributes['UpgradeCode']
  end

  def test_wxs_file_has_manufacturer_folder
    Packup.stuff 'Magic' do
      author 'Wizard'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    dirs = REXML::XPath.match wxs, '//Directory'
    dirs.delete_if { |dir| dir.attributes['Id'] != 'ManufacturerFolder' }
    assert_equal 'Wizard', dirs.first.attributes['Name']
  end

  def test_wxs_file_has_product_folder
    Packup.stuff 'Magic'
    Rake::Task['wix/Magic.wxs'].invoke
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    dirs = REXML::XPath.match wxs, '//Directory'
    dirs.delete_if { |dir| dir.attributes['Id'] != 'INSTALLDIR' }
    assert_equal 'Magic', dirs.first.attributes['Name']
  end

  def test_wxs_file_creates_source_file
    Packup.stuff 'Magic' do
      file 'README.md' => 'README.md'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    assert File.exist?('wix/src/README.md')
  end

  def test_wxs_file_creates_source_folder
    Packup.stuff 'Magic' do
      file 'README.md' => 'Wand/README.md'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    assert File.directory?('wix/src/Wand')
  end

  def test_wxs_file_references_sourcery_components
    Packup.stuff 'Magic' do
      file 'README.md' => 'README.md'
    end
    Rake::Task['wix/Magic.wxs'].invoke
    sourcery = REXML::Document.new File.read('wix/Sourcery.wxs')
    components = REXML::XPath.match sourcery, '//Component'
    components.map! { |component| component.attributes['Id'] }
    wxs = REXML::Document.new File.read('wix/Magic.wxs')
    refs = REXML::XPath.match wxs, '//ComponentRef'
    refs.map! { |ref| ref.attributes['Id'] }
    assert_equal components, refs
  end
end
