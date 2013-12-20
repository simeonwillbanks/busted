require "singleton"

module Busted
  module Profiler
    class Sandwich

      include Singleton

      include Busted::Traceable
      include Busted::Countable

      VALID_ACTIONS = [:start, :finish].freeze

      attr_accessor :action
      attr_reader :trace, :report

      def self.run(options = {})
        action = options.fetch :action, false
        trace = options.fetch :trace, false

        unless VALID_ACTIONS.include? action
          fail ArgumentError, "profiler requires start or finish action"
        end

        sandwich = instance

        sandwich.action = action
        sandwich.trace = trace
        sandwich.run
      end

      def initialize
        @report = {}
      end

      def run
        send action
      end

      def trace=(trace)
        @trace = trace if start?
      end

      private

      def start?
        action == :start
      end

      def start
        start_tracer
        start_counter
      end

      def finish
        finish_counter
        finish_tracer
        report
      end
    end
  end
end
