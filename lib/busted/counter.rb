module Busted
  class Counter

    def start
      @started = counts
    end

    def finish
      @finished = counts
    end

    def report
      [:method, :constant].each_with_object({}) do |counter, result|
        result[counter] = finished[counter] - started[counter]
      end
    end

    private

    attr_reader :started, :finished

    def counts
      stat = RubyVM.stat
      {
        method:   stat[:global_method_state],
        constant: stat[:global_constant_state]
      }
    end
  end
end
