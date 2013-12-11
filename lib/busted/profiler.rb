require "busted/profiler/default"

module Busted
  module Profiler
    extend self

    def run(*args, &blk)
      klass(args.first).run(&blk)
    end

    private

    def klass(profiler)
      Busted::Profiler.const_get (profiler || :default).capitalize
    rescue NameError
      fail ArgumentError, "profiler `#{profiler}' does not exist"
    end
  end
end
