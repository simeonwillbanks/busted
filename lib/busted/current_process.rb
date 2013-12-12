module Busted
  module CurrentProcess
    extend self

    def privileged?
      if root? || sudoer?
        true
      else
        false
      end
    end

    def root?
      Process.euid == 0
    end

    def sudoer?
      system "sudo echo ok > /dev/null 2>&1"
    rescue Errno::EPERM
      false
    end
  end
end
