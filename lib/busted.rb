require "busted/version"
require "busted/profiler"

module Busted
  extend self

  def run(*args, &blk)
    Busted::Profiler.run *args, &blk
  end

  def method_cache_invalidations(&blk)
    run(&blk)[:invalidations][:method]
  end

  def constant_cache_invalidations(&blk)
    run(&blk)[:invalidations][:constant]
  end

  def cache?(counter = nil, &blk)
    total = if counter
              send :"#{counter}_cache_invalidations", &blk
            else
              run(&blk)[:invalidations].values.inject :+
            end
    total > 0
  end

  def method_cache?(&blk)
    cache? :method, &blk
  end

  def constant_cache?(&blk)
    cache? :constant, &blk
  end
end
