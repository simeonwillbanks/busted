require "test_helper"

class Busted::StackTest < MiniTest::Unit::TestCase
  def test_lifo_with_one_set_of_counts
    stack = Busted::Stack.new
    stack.started = 1
    stack.finished = 1
    assert_equal 1, stack.started
    assert_equal 1, stack.finished
  end

  def test_lifo_with_three_sets_of_counts
    stack = Busted::Stack.new
    stack.started = 1
    stack.started = 2
    stack.started = 3
    stack.finished = 1
    stack.finished = 2
    stack.finished = 3
    assert_equal 3, stack.started
    assert_equal 3, stack.finished
  end
end
