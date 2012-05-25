$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 

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

  def test_version_is_settable
    inside = nil
    Packup.stuff 'Magic' do
      version '1.0.0'
      inside = version
    end
    assert_equal '1.0.0', inside
  end

  def test_version_is_nil_if_not_set
    inside = nil
    Packup.stuff 'Magic' do
      inside = version
    end
    assert_nil inside
  end
end
