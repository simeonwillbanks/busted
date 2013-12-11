require "busted/profiler/default"

module Busted
  module Profiler
    extend self

    def run(*args, &blk)
      klass(args.first).run(&blk)
    end

    private

    def klass(profiler)
      Busted::Profiler.const_get name(profiler)
    rescue NameError
      fail ArgumentError, "profiler `#{profiler}' does not exist"
    end

    def name(profiler)
      (profiler || :default).to_s.tap { |s| s[0] = s[0].upcase }
    end
  end
end
