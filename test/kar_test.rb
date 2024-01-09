# frozen_string_literal: true

require "test_helper"

class KarTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Kar.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
