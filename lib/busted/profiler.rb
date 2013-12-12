require "busted/counter"
require "busted/countable"
require "busted/tracer"
require "busted/traceable"
require "busted/profiler/default"

module Busted
  module Profiler
    extend self

    def run(options, &block)
      klass(options.fetch :profiler, :default).new(options, &block).run
    end

    private

    def klass(profiler)
      Profiler.const_get profiler.capitalize
    rescue NameError
      fail ArgumentError, "profiler `#{profiler}' does not exist"
    end
  end
end
