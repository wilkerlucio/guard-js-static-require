require "test_helper"

class TestJsStaticRequire < MiniTest::Unit::TestCase
  def setup
    @guard = Guard::JsStaticRequire.new([], {})
  end

  def test_scan_path_sending_a_file
    assert_equal ["lib/guard/js_static_require.rb"], @guard.scan_path("lib/guard/js_static_require.rb")
  end

  def test_scan_path_with_directory
    assert_equal ["test/fixtures/js-tree/file.js",
                  "test/fixtures/js-tree/internal/file1.js",
                  "test/fixtures/js-tree/internal/file2.js"], @guard.scan_path("test/fixtures/js-tree")
  end
end
