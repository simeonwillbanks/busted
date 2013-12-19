module Busted
  module Profiler
    class Default

      include Busted::Traceable
      include Busted::Countable

      attr_reader :trace, :block, :report

      def initialize(options = {}, &block)
        fail LocalJumpError, "no block given" unless block

        @trace = options.fetch :trace, false
        @block = block
        @report = {}
      end

      def run
        start_tracer
        start_counter

        block.call

        finish_counter
        finish_tracer

        report
      end
    end
  end
end
