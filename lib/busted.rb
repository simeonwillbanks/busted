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
    case serial
    when :method
      RubyVM.method_serial
    when :constant
      RubyVM.constant_serial
    else
      RubyVM.method_serial + RubyVM.constant_serial
    end
  end
end
