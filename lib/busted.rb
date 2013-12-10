require "busted/version"

module Busted
  extend self

  def cache_invalidations(&blk)
    starting = counts
    yield
    ending = counts

    [:method, :constant, :class].each_with_object({}) do |serial, result|
      result[serial] = ending[serial] - starting[serial]
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

  def cache?(serial = nil, &blk)
    total = if serial
              send :"#{serial}_cache_invalidations", &blk
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
      method:   stat[:method_serial],
      constant: stat[:constant_serial],
      class:    stat[:class_serial]
    }
  end
end
