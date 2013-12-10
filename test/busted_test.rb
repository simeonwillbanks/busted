require "test_helper"

class BustedTest < MiniTest::Unit::TestCase
  def test_cache_invalidations_requires_block
    assert_raises LocalJumpError do
      Busted.cache_invalidations
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
    invalidations = Busted.cache_invalidations { }
    assert_equal 0, invalidations[:method]
    assert_equal 0, invalidations[:constant]
  end

  def test_method_cache_invalidations_with_empty_block
    assert_equal 0, Busted.method_cache_invalidations { }
  end

  def test_constant_cache_invalidations_with_empty_block
    assert_equal 0, Busted.constant_cache_invalidations { }
  end

  def test_cache_invalidations_with_addition
    invalidations = Busted.cache_invalidations { 1 + 1 }
    assert_equal 0, invalidations[:method]
    assert_equal 0, invalidations[:constant]
  end

  def test_method_cache_invalidations_with_addition
    assert_equal 0, Busted.method_cache_invalidations { 1 + 1 }
  end

  def test_constant_cache_invalidations_with_addition
    assert_equal 0, Busted.constant_cache_invalidations { 1 + 1 }
  end

  def test_cache_invalidations_with_new_constant
    invalidations = Busted.cache_invalidations do
      self.class.const_set :"CHEESE", "cheese"
    end
    assert_equal 0, invalidations[:method]
    assert invalidations[:constant] > 0
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

  def test_cache_invalidations_with_new_method
    invalidations = Busted.cache_invalidations do
      Object.class_exec { def cheese; end }
    end
    assert invalidations[:method] > 0
    assert_equal 0, invalidations[:constant]
  end

  def test_method_cache_invalidations_with_new_method
    invalidations = Busted.method_cache_invalidations do
      Object.class_exec { def hawaiian; end }
    end
    assert invalidations > 0
  end

  def test_constant_cache_invalidations_with_new_method
    invalidations = Busted.constant_cache_invalidations do
      Object.class_exec { def vegetable; end }
    end
    assert_equal 0, invalidations
  end

  def test_cache_invalidations_with_new_class
    invalidations = Busted.cache_invalidations do
      Object.class_eval "class ThreeCheese; end"
    end
    assert_equal 0, invalidations[:method]
    assert_equal 1, invalidations[:constant]
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
end
