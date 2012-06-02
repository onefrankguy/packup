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

  def test_create_msi_file_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined? 'wix/Magic.msi'
  end

  def test_create_source_file_task
    Packup.stuff 'Magic' do
      file 'README.md' => 'README.md'
    end
    assert Rake::FileTask.task_defined? 'README.md'
  end

  def test_create_destination_file_task
    Packup.stuff 'Magic' do
      file 'README.md' => 'README.md'
    end
    assert Rake::FileTask.task_defined? 'wix/src/README.md'
  end

  def test_create_sourcery_wxs_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
  end

  def test_create_sourcery_wixobj_task
    Packup.stuff 'Magic'
    assert Rake::FileTask.task_defined?('wix/Sourcery.wixobj')
  end

  def test_create_clean_task
    Packup.stuff 'Magic'
    assert Rake::Task.task_defined? :clean
  end

  def test_create_msi_task
    Packup.stuff 'Magic'
    assert Rake::Task.task_defined? :msi
  end

  def test_create_test_task
    Packup.stuff 'Magic'
    assert Rake::Task.task_defined? :test
  end
end
