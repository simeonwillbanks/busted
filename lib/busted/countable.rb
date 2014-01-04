module Busted
  module Countable

    attr_reader :counter
    attr_writer :report

    def start_counter
      @counter ||= Counter.new

      counter.start
    end

    def finish_counter
      counter.finish

      report[:invalidations] = counter.report
    end
  end
end
