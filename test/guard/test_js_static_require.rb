require "test_helper"

class TestJsStaticRequire < MiniTest::Unit::TestCase
  def setup
    @guard = Guard::JsStaticRequire.new([], {})
  end

  def test_scan_path_sending_a_file
    assert_equal ["lib/guard/js_static_require.rb"], @guard.scan_path("lib/guard/js_static_require.rb")
  end
end
