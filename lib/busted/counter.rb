require "monitor"
require "busted/stack"

module Busted
  class Counter

    def initialize(stack = Stack.new)
      @stack = stack
      @lock = Monitor.new
    end

    def start
      lock.synchronize { stack.started = counts }
    end

    def finish
      lock.synchronize { stack.finished = counts }
    end

    def report
      lock.synchronize do
        started = stack.started
        finished = stack.finished

        [:method, :constant].each_with_object({}) do |counter, result|
          result[counter] = finished[counter] - started[counter]
        end
      end
    end

    private

    attr_reader :stack, :lock

    def counts
      stat = RubyVM.stat
      {
        method:   stat[:global_method_state],
        constant: stat[:global_constant_state]
      }
    end
  end
end
