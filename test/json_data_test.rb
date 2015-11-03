require 'test_helper'

class JSONDataTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::JSONData::VERSION
  end
end
