require "busted/counter"
require "busted/countable"
require "busted/tracer"
require "busted/traceable"

module Busted
  module Profiler
    extend self

    autoload :Default, "busted/profiler/default"
    autoload :Sandwich, "busted/profiler/sandwich"

    def run(options, &block)
      klass(options.fetch :profiler, :default).run(options, &block)
    end

    private

    def klass(profiler)
      Profiler.const_get profiler.capitalize
    rescue NameError
      fail ArgumentError, "profiler `#{profiler}' does not exist"
    end
  end
end
