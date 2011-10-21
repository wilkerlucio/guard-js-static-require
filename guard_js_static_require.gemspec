# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/js-static-require/version"

Gem::Specification.new do |s|
  s.name        = "guard-js-static-require"
  s.version     = Guard::JsStaticRequireVersion::VERSION
  s.authors     = ["Wilker Lucio"]
  s.email       = ["wilkerlucio@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Automatic replace script tags for loading files}
  s.description = %q{This guard watches for new/removed javascript files and automatic inject the script tags for loading them on an html page.}

  s.rubyforge_project = "guard-js-static-require"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "growl_notify"
end
