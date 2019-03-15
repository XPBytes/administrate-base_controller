require 'test_helper'

module Administrate
  class BaseControllerTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Administrate::BaseController::VERSION
    end
  end
end
