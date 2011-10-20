require "test_helper"

class TestJsStaticRequire < MiniTest::Unit::TestCase
  def setup
    @guard = Guard::Jsstaticrequire.new([], {
      :start_delim => /<!-- s -->/,
      :end_delim   => /<!-- e -->/
    })
  end

  def test_scan_libs
    assert_equal ["test/fixtures/js-tree/internal/file1.js",
                  "test/fixtures/js-tree/file.js",
                  "test/fixtures/js-tree/a/before.js",
                  "test/fixtures/js-tree/internal/file2.js"], @guard.scan_libs(["test/fixtures/js-tree/internal/file1.js", "test/fixtures/js-tree"])
  end

  def test_scan_path_sending_a_file
    assert_equal ["lib/guard/js_static_require.rb"], @guard.scan_path("lib/guard/js_static_require.rb")
  end

  def test_scan_path_with_directory
    assert_equal ["test/fixtures/js-tree/file.js",
                  "test/fixtures/js-tree/a/before.js",
                  "test/fixtures/js-tree/internal/file1.js",
                  "test/fixtures/js-tree/internal/file2.js"], @guard.scan_path("test/fixtures/js-tree")
  end

  def test_code_injection
    string = "hello <!-- s --><!-- e --> dad"
    assert_equal "hello <!-- s -->inside<!-- e --> dad", @guard.inject("inside", string)
  end

  def test_code_injection_invalid
    string = "hello <!-- u --><!-- e --> dad"
    assert_equal "hello <!-- u --><!-- e --> dad", @guard.inject("inside", string)
  end

  def test_tabulation
    string = "hello\n    <!-- s -->"
    assert_equal("    ", @guard.tabulation(string))
  end

  def test_tabulation_with_string_on_beginning_of_line
    string = "hello\n a    <!-- s -->"
    assert_equal(" ", @guard.tabulation(string))
  end

  def test_tabulation_on_first_line
    string = "    <!-- s -->"
    assert_equal("    ", @guard.tabulation(string))
  end

  def test_build_load_string
    @guard.files = ["vendor/jquery.js", "vendor/underscore.js"]
    @guard.options[:updates] = "examples/index.html"

    expected = %Q{\n  <script type="text/javascript" src="../vendor/jquery.js"></script>\n  <script type="text/javascript" src="../vendor/underscore.js"></script>\n  }

    assert_equal(expected, @guard.build_load_string("  <!-- s -->"))
  end

  def test_relative_path
    assert_equal("../lib/library.js", @guard.relative_path("examples/index.html", "lib/library.js"))
    assert_equal("lib/library.js", @guard.relative_path("index.html", "lib/library.js"))
    assert_equal("../library.js", @guard.relative_path("examples/index.html", "library.js"))
  end
end
