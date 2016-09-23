require "test_helper"

class Busted::CurrentProcessTest < Minitest::Test

  def test_privileged_because_root
    Process.stub :euid, 0 do
      assert Busted::CurrentProcess.privileged?
    end
  end

  def test_privileged_because_sudoer
    Process.stub :euid, 1980 do
      # TODO
      # Reliably stub Object#system
      Busted::CurrentProcess.stub :sudoer?, true do
        assert Busted::CurrentProcess.privileged?
      end
    end
  end

  def test_not_privileged
    Process.stub :euid, 1980 do
      # TODO
      # Reliably stub Object#system
      Busted::CurrentProcess.stub :sudoer?, false do
        refute Busted::CurrentProcess.privileged?
      end
    end
  end
end
