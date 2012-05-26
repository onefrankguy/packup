$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

require 'packup'
require 'test/unit'

class PackupTasksTest < Test::Unit::TestCase
  def setup
    Rake::Task.clear
  end

  def test_creates_wix_folder_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined? 'wix'
  end

  def test_create_wxs_file_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined? 'wix/Magic.wxs'
  end

  def test_create_wixobj_file_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined? 'wix/Magic.wixobj'
  end
end
