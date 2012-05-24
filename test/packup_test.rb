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
end
