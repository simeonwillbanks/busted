# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busted/version"

Gem::Specification.new do |spec|
  spec.name          = "busted"
  spec.version       = Busted::VERSION
  spec.authors       = ["Simeon F. Willbanks"]
  spec.email         = ["sfw@simeonfosterwillbanks.com"]
  spec.description   = %q{Find code that busts the Ruby cache.}
  spec.summary       = <<-DESC
    MRI Ruby defines RubyVM.stat which accesses internal cache counters.
    Busted reports when code increments these counters thereby busting the cache.
  DESC
  spec.homepage      = "https://github.com/simeonwillbanks/busted"
  spec.license       = "MIT"

  spec.files         = [".ruby-version", "CONTRIBUTING.md", "Gemfile",
                        "LICENSE.txt", "README.md", "Rakefile",
                        "busted.gemspec", "lib/busted.rb",
                        "lib/busted/version.rb", "test/busted_test.rb",
                        "test/test_helper.rb"]
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
