require "busted/stack"

module Busted
  class Counter

    def initialize(stack = Stack.new)
      @stack = stack
    end

    def start
      stack.started = counts
    end

    def finish
      stack.finished = counts
    end

    def report
      started = stack.started
      finished = stack.finished

      [:method, :constant].each_with_object({}) do |counter, result|
        result[counter] = finished[counter] - started[counter]
      end
    end

    private

    attr_reader :stack

    def counts
      stat = RubyVM.stat
      {
        method:   stat[:global_method_state],
        constant: stat[:global_constant_state]
      }
    end
  end
end
