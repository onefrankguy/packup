$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'test/unit'

class PackupMsiTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
    FileUtils.remove_dir 'wix', true
  end

  def test_msi_file_gets_created
    Packup.stuff 'Magic' do
      version '1.0.0'
      author 'Wizard'
      file 'README.md' => 'README.md'
    end
    Rake::Task['wix/Magic.msi'].invoke
    assert File.exists? 'wix/Magic.msi'
  end
end
