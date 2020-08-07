require 'test_helper'

class BrewTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Brew::VERSION
  end
end
