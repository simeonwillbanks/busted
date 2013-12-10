require "busted/version"

module Busted
  extend self

  def cache_invalidations(&blk)
    starting = counts
    yield
    ending = counts

    [:method, :constant, :class].each_with_object({}) do |counter, result|
      result[counter] = ending[counter] - starting[counter]
    end
  end

  def method_cache_invalidations(&blk)
    cache_invalidations(&blk)[:method]
  end

  def constant_cache_invalidations(&blk)
    cache_invalidations(&blk)[:constant]
  end

  def class_cache_invalidations(&blk)
    cache_invalidations(&blk)[:class]
  end

  def cache?(counter = nil, &blk)
    total = if counter
              send :"#{counter}_cache_invalidations", &blk
            else
              cache_invalidations(&blk).values.inject :+
            end
    total > 0
  end

  def method_cache?(&blk)
    cache? :method, &blk
  end

  def constant_cache?(&blk)
    cache? :constant, &blk
  end

  def class_cache?(&blk)
    cache? :class, &blk
  end

  private

  def counts
    stat = RubyVM.stat
    {
      method:   stat[:global_method_state],
      constant: stat[:global_constant_state],
      class:    stat[:class_serial]
    }
  end
end
