# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busted/version"

Gem::Specification.new do |spec|
  spec.name          = "busted"
  spec.version       = Busted::VERSION
  spec.authors       = ["Simeon F. Willbanks"]
  spec.email         = ["sfw@simeonfosterwillbanks.com"]
  spec.description   = "Find code that busts the Ruby cache."
  spec.summary       = <<-DESC
    MRI Ruby defines RubyVM.stat which accesses internal cache counters.
    When the cache counters are incremented, the internal cache is invalidated.
    Busted reports when code increments these counters.
  DESC
  spec.homepage      = "https://github.com/simeonwillbanks/busted"
  spec.license       = "MIT"

  spec.files         = %w(
    .ruby-version
    CONTRIBUTING.md
    Gemfile
    LICENSE.txt
    README.md
    Rakefile
    busted.gemspec
    dtrace/probes/busted/method-cache-clear.d
    dtrace/probes/examples/method-cache-clear.d
    lib/busted.rb
    lib/busted/countable.rb
    lib/busted/counter.rb
    lib/busted/current_process.rb
    lib/busted/profiler.rb
    lib/busted/profiler/default.rb
    lib/busted/traceable.rb
    lib/busted/tracer.rb
    lib/busted/version.rb
    test/busted/current_process_test.rb
    test/busted_test.rb
    test/test_helper.rb
  )
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
