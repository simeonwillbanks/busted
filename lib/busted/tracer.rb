require "tempfile"

module Busted
  class Tracer

    class FinishedException < Exception; end
    class MissingCommandError < StandardError; end

    def self.exists?
      system "hash dtrace 2>/dev/null"
    end

    def initialize
      @lines = ""
    end

    def start
      spawn
      wait until started?
    end

    def finish
      final_probe
      wait until finished?
      kill
    ensure
      clean_up
    end

    def report
      lines.split("\n").each_with_object({method: []}) do |line, result|
        next if line =~ /\ABusted/
        trace = line.split
        result[:method] << { class: trace[0], sourcefile: trace[1], lineno: trace[2] }
      end
    end

    private

    attr_accessor :lines
    attr_reader :pid

    def wait
      sleep 0.1
    end

    def started?
      !(lines << log.read).empty?
    end

    def finished?
      (lines << log.read) =~ /Busted::Tracer::FinishedException/
    end

    def final_probe
      raise FinishedException
    rescue FinishedException
    end

    def spawn
      @pid = Process.spawn command, STDERR => STDOUT
    end

    def kill
      `sudo kill -TERM #{pid}`
    end

    def parent_pid
      Process.pid
    end

    def probe
      File.expand_path "../../../dtrace/probes/busted/method-cache-clear.d", __FILE__
    end

    def log
      @log ||= Tempfile.new "busted-dtrace.log"
    end

    def clean_up
      log.close!
    end

    def command
      "sudo dtrace -q -o #{log.path} -s #{probe} -p #{parent_pid}"
    end
  end
end
