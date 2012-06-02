require 'packup'
require 'test/unit'

class PackupTest < Test::Unit::TestCase
  def test_has_name_outside_block
    package = Packup.stuff 'Magic'
    assert_equal 'Magic', package.name
  end

  def test_has_name_inside_block
    inside = nil
    Packup.stuff 'Magic' do
    	inside = name
    end
    assert_equal 'Magic', inside
  end

  def test_set_version
    inside = nil
    Packup.stuff 'Magic' do
      version '1.0.0'
      inside = version
    end
    assert_equal '1.0.0', inside
  end

  def test_default_version
    inside = 0 
    Packup.stuff 'Magic' do
      inside = version
    end
    assert_nil inside
  end

  def test_set_author
    inside = nil
    Packup.stuff 'Magic' do
      author 'Wizard'
      inside = author
    end
    assert_equal 'Wizard', inside
  end

  def test_default_author
    inside = 0 
    Packup.stuff 'Magic' do
      inside = author
    end
    assert_nil inside
  end

  def test_set_files
    inside = nil
    Packup.stuff 'Magic' do
      file 'rabbit.txt' => 'hat.txt'
      inside = files
    end
    assert_equal 'wix/src/hat.txt', inside['rabbit.txt']
  end

  def test_default_files
    inside = nil
    Packup.stuff 'Magic' do
      inside = files
    end
    assert_equal 0, inside.length
  end
end
