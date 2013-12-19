require "busted/current_process"

module Busted
  module Traceable

    attr_reader :trace, :tracer
    attr_writer :report

    def trace?
      trace
    end

    def start_tracer
      return unless trace?

      unless Tracer.exists?
        fail Tracer::MissingCommandError, "tracer requires dtrace"
      end

      unless CurrentProcess.privileged?
        fail Errno::EPERM, "dtrace requires root privileges"
      end

      @tracer = Tracer.new

      tracer.start
    end

    def finish_tracer
      return unless trace?

      tracer.finish

      report[:traces] = tracer.report
    end
  end
end
