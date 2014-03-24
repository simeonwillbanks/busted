require "monitor"

module Busted
  class Stack
    def initialize
      @started = []
      @finished = []
      @lock = Monitor.new
    end

    def started
      @lock.synchronize { @started.pop }
    end

    def started=(element)
      @lock.synchronize { @started.push element }
    end

    def finished
      @lock.synchronize { @finished.pop }
    end

    def finished=(element)
      @lock.synchronize { @finished.push element }
    end
  end
end
