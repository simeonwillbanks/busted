require "test_helper"

class BustedTest < Minitest::Test
  def test_invalid_profiler_exception
    error = assert_raises ArgumentError do
      Busted.run profiler: :pizza
    end
    assert_equal "profiler `pizza' does not exist", error.message
  end

  def test_invalid_profiler_action_exception
    error = assert_raises ArgumentError do
      Busted.start profiler: :sandwich, action: :pizza
    end
    assert_equal "profiler requires start or finish action", error.message
  end

  def test_cache_invalidations_requires_block
    assert_raises LocalJumpError do
      Busted.run
    end
  end

  def test_method_cache_invalidations_requires_block
    assert_raises LocalJumpError do
      Busted.method_cache_invalidations
    end
  end

  def test_constant_cache_invalidations_requires_block
    assert_raises LocalJumpError do
      Busted.constant_cache_invalidations
    end
  end

  def test_cache_invalidations_with_empty_block
    report = Busted.run { }
    assert_equal 0, report[:invalidations][:method]
    assert_equal 0, report[:invalidations][:constant]
  end

  def test_method_cache_invalidations_with_empty_block
    assert_equal 0, Busted.method_cache_invalidations { }
  end

  def test_constant_cache_invalidations_with_empty_block
    assert_equal 0, Busted.constant_cache_invalidations { }
  end

  def test_cache_invalidations_with_addition
    report = Busted.run { 1 + 1 }
    assert_equal 0, report[:invalidations][:method]
    assert_equal 0, report[:invalidations][:constant]
  end

  def test_method_cache_invalidations_with_addition
    assert_equal 0, Busted.method_cache_invalidations { 1 + 1 }
  end

  def test_constant_cache_invalidations_with_addition
    assert_equal 0, Busted.constant_cache_invalidations { 1 + 1 }
  end

  def test_start_finish_with_addition
    Busted.start
    1 + 1
    report = Busted.finish
    assert_equal 0, report[:invalidations][:method]
    assert_equal 0, report[:invalidations][:constant]
  end

  def test_cache_invalidations_with_new_constant
    report = Busted.run { self.class.const_set :"CHEESE", "cheese" }
    assert_equal 0, report[:invalidations][:method]
    assert_equal 1, report[:invalidations][:constant]
  end

  def test_method_cache_invalidations_with_new_constant
    invalidations = Busted.method_cache_invalidations do
      self.class.const_set :"HAWAIIAN", "hawaiian"
    end
    assert_equal 0, invalidations
  end

  def test_constant_cache_invalidations_with_new_constant
    invalidations = Busted.constant_cache_invalidations do
      self.class.const_set :"VEGETABLE", "vegetable"
    end
    assert_equal 1, invalidations
  end

  def test_start_finish_with_new_constant
    Busted.start
    self.class.const_set :"PEPPERONI", "pepperoni"
    report = Busted.finish
    assert_equal 0, report[:invalidations][:method]
    assert_equal 1, report[:invalidations][:constant]
  end

  def test_cache_invalidations_with_new_method
    report = Busted.run { Object.class_exec { def cheese; end } }
    assert_equal 1, report[:invalidations][:method]
    assert_equal 0, report[:invalidations][:constant]
  end

  def test_method_cache_invalidations_with_new_method
    invalidations = Busted.method_cache_invalidations do
      Object.class_exec { def hawaiian; end }
    end
    assert_equal 1, invalidations
  end

  def test_constant_cache_invalidations_with_new_method
    invalidations = Busted.constant_cache_invalidations do
      Object.class_exec { def vegetable; end }
    end
    assert_equal 0, invalidations
  end

  def test_start_finish_with_new_method
    Busted.start
    Object.class_exec { def pepperoni; end }
    report = Busted.finish
    assert_equal 1, report[:invalidations][:method]
    assert_equal 0, report[:invalidations][:constant]
  end

  def test_cache_invalidations_with_new_class
    report = Busted.run { Object.class_eval "class ThreeCheese; end" }
    assert_equal 0, report[:invalidations][:method]
    assert_equal 1, report[:invalidations][:constant]
  end

  def test_method_cache_invalidations_with_new_class
    invalidations = Busted.method_cache_invalidations do
      Object.class_eval "class SweetHawaiian; end"
    end
    assert_equal 0, invalidations
  end

  def test_constant_cache_invalidations_with_new_class
    invalidations = Busted.constant_cache_invalidations do
      Object.class_eval "class Veggie; end"
    end
    assert_equal 1, invalidations
  end

  def test_start_finish_with_new_class
    Busted.start
    Object.class_eval "class Pepperoni; end"
    report = Busted.finish
    assert_equal 0, report[:invalidations][:method]
    assert_equal 1, report[:invalidations][:constant]
  end

  def test_cache_predicate_requires_block
    assert_raises LocalJumpError do
      Busted.cache?
    end
  end

  def test_method_cache_predicate_requires_block
    assert_raises LocalJumpError do
      Busted.method_cache?
    end
  end

  def test_constant_cache_predicate_requires_block
    assert_raises LocalJumpError do
      Busted.constant_cache?
    end
  end

  def test_cache_predicate_with_empty_block
    refute Busted.cache? { }
  end

  def test_method_cache_predicate_with_empty_block
    refute Busted.method_cache? { }
  end

  def test_constant_cache_predicate_with_empty_block
    refute Busted.constant_cache? { }
  end

  def test_cache_predicate_with_addition
    refute Busted.cache? { 1 + 1 }
  end

  def test_method_cache_predicate_with_addition
    refute Busted.method_cache? { 1 + 1 }
  end

  def test_constant_cache_predicate_with_addition
    refute Busted.constant_cache? { 1 + 1 }
  end

  def test_cache_predicate_with_new_constant
    assert Busted.cache? { self.class.const_set :"PORTER", "porter" }
  end

  def test_method_cache_predicate_with_new_constant
    refute Busted.method_cache? { self.class.const_set :"SCHWARZBIER", "schwarzbier" }
  end

  def test_constant_cache_predicate_with_new_constant
    assert Busted.constant_cache? { self.class.const_set :"STOUT", "stout" }
  end

  def test_cache_predicate_with_new_method
    assert Busted.cache? { Object.class_exec { def porter; end } }
  end

  def test_method_cache_predicate_with_new_method
    assert Busted.method_cache? { Object.class_exec { def schwarzbier; end } }
  end

  def test_constant_cache_predicate_with_new_method
    refute Busted.constant_cache? { Object.class_exec { def stout; end } }
  end

  def test_cache_predicate_with_new_class
    assert Busted.cache? { Object.class_eval "class PierRatPorter; end" }
  end

  def test_method_cache_predicate_with_new_class
    refute Busted.method_cache? { Object.class_eval "class MidnightExpression; end" }
  end

  def test_constant_cache_predicate_with_new_class
    assert Busted.constant_cache? { Object.class_eval "class SantasLittleHelper; end" }
  end

  def test_nesting_run
    outer_report = {}
    inner_report = {}

    outer_report = Busted.run do

      Object.class_eval "class CarlsbadChronic; end"

      inner_report = Busted.run do

        Object.class_eval "class SharkBite; end"
      end
    end

    assert_equal({invalidations:{method:0,constant:1}}, inner_report)
    assert_equal({invalidations:{method:0,constant:2}}, outer_report)
  end

  def test_nesting_start_finish
    outer_report = {}
    inner_report = {}

    Busted.start

    Object.class_eval "class ExtraCheese; end"

    Busted.start

    Object.class_eval "class ExtraExtraCheese; end"

    inner_report = Busted.finish

    Object.class_eval "class TooMuchCheese; end"

    outer_report = Busted.finish

    assert_equal({invalidations:{method:0,constant:1}}, inner_report)
    assert_equal({invalidations:{method:0,constant:3}}, outer_report)
  end

  def test_start_return_value
    assert_equal true, Busted.start
    Busted.finish
  end

  if Busted::Tracer.exists? && Busted::CurrentProcess.privileged?

    def test_cache_invalidations_and_traces_with_new_method
      report = Busted.run(trace: true) { Object.class_exec { def cookie; end } }
      assert_equal 1, report[:invalidations][:method]
      assert_equal 0, report[:invalidations][:constant]
      assert_equal "global", report[:traces][:method][0][:class]
      assert_match /test\/busted_test.rb\z/, report[:traces][:method][0][:sourcefile]
      assert_equal "#{__LINE__ - 5}", report[:traces][:method][0][:lineno]
    end

    def test_start_finish_and_traces_with_new_method
      Busted.start trace: true
      Object.class_exec { def candy; end }
      report = Busted.finish
      assert_equal 1, report[:invalidations][:method]
      assert_equal 0, report[:invalidations][:constant]
      assert_equal "global", report[:traces][:method][0][:class]
      assert_match /test\/busted_test.rb\z/, report[:traces][:method][0][:sourcefile]
      assert_equal "#{__LINE__ - 6}", report[:traces][:method][0][:lineno]
    end
  end

  def test_trace_without_root_privileges
    Busted::Tracer.stub :exists?, true do
      Busted::CurrentProcess.stub :privileged?, false do
        error = assert_raises Errno::EPERM do
          Busted.run(trace: true) { Object.class_exec { def ice_cream; end } }
        end
        assert_equal "Operation not permitted - dtrace requires root privileges", error.message
      end
    end
  end

  def test_trace_without_dtrace_installed
    Busted::Tracer.stub :exists?, false do
      error = assert_raises Busted::Tracer::MissingCommandError do
        Busted.run(trace: true) { Object.class_exec { def pie; end } }
      end
      assert_equal "tracer requires dtrace", error.message
    end
  end
end
