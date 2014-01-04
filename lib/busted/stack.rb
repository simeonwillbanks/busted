module Busted
  class Stack
    def initialize
      @started = []
      @finished = []
    end

    def started
      @started.pop
    end

    def started=(element)
      @started.push element
    end

    def finished
      @finished.pop
    end

    def finished=(element)
      @finished.push element
    end
  end
end
