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

  def test_absolute_install_path_becomes_relative
    Packup.stuff 'Magic' do
      file 'README.md' => '/doc/README.md'
    end
    Rake::Task['wix/src/doc/README.md'].invoke
    assert File.exists? 'wix/src/doc/README.md'
  end
end
