require 'packup'
require 'test/unit'

class PackupWixobjTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
    FileUtils.remove_dir 'wix', true
  end

  def test_wixobj_file_gets_created
    Packup.stuff 'Magic' do
      version '1.0.0'
      author 'Wizard'
    end
    Rake::Task['wix/Magic.wixobj'].invoke
    assert File.exists? 'wix/Magic.wixobj'
  end
end
