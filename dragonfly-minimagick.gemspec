# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dragonfly-minimagick/version"

Gem::Specification.new do |s|
  s.name        = "dragonfly-minimagick"
  s.version     = Dragonfly::Minimagick::VERSION
  s.authors     = ["Paul Spieker"]
  s.email       = ["p.spieker@duenos.de"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "dragonfly-minimagick"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("dragonfly", [">= 0.9"])
  s.add_dependency("mini_magick", ["~> 3.3"])
  s.add_development_dependency("rspec", [">= 2.0"])
end
