module Busted
  module Profiler
    module Default
      extend self

      def run(&blk)
        starting = counts
        yield
        ending = counts

        report = { invalidations: {} }

        [:method, :constant].each_with_object(report) do |counter, result|
          result[:invalidations][counter] = ending[counter] - starting[counter]
        end
      end

      private

      def counts
        stat = RubyVM.stat
        {
          method:   stat[:global_method_state],
          constant: stat[:global_constant_state]
        }
      end
    end
  end
end
