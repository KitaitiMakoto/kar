# frozen_string_literal: true

require_relative "helper"

class TestKar < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Kar.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
