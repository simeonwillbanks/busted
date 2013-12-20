require "busted/profiler"

module Busted
  extend self

  def run(options = {}, &block)
    Profiler.run options, &block
  end

  def start(options = {})
    Profiler.run({ profiler: :sandwich, action: :start }.merge options)
  end

  def finish(options = {})
    Profiler.run({ profiler: :sandwich, action: :finish }.merge options)
  end

  def method_cache_invalidations(&block)
    run(&block)[:invalidations][:method]
  end

  def constant_cache_invalidations(&block)
    run(&block)[:invalidations][:constant]
  end

  def cache?(counter = nil, &block)
    total = if counter
              send :"#{counter}_cache_invalidations", &block
            else
              run(&block)[:invalidations].values.inject :+
            end
    total > 0
  end

  def method_cache?(&block)
    cache? :method, &block
  end

  def constant_cache?(&block)
    cache? :constant, &block
  end
end
