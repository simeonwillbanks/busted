require "busted/version"

module Busted
  extend self

  def cache?(serial = nil, &blk)
    starting = count serial
    yield
    ending = count serial
    ending > starting
  end

  def method_cache?(&blk)
    cache? :method, &blk
  end

  def constant_cache?(&blk)
    cache? :constant, &blk
  end

  private

  def count(serial)
    stat = RubyVM.stat
    case serial
    when :method
      stat[:method_serial]
    when :constant
      stat[:constant_serial]
    else
      stat[:method_serial] + stat[:constant_serial]
    end
  end
end
