$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'test/unit'

class PackupBehaviorTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
    FileUtils.remove_dir 'wix', true
  end

  def test_wix_task_creates_wix_folder
    Packup.stuff 'Magic'
    Rake::Task['wix'].invoke
    assert File.exists? 'wix'
  end

  def test_clean_task_removes_wix_folder
    Packup.stuff 'Magic'
    Rake::Task['wix'].invoke
    Rake::Task[:clean].invoke
    assert !File.exists?('wix')
  end
end
