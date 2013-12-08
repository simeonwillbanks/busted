require "test_helper"

class BustedTest < MiniTest::Unit::TestCase
  def test_cache_requires_block
    assert_raises LocalJumpError do
      Busted.cache
    end
  end

  def test_method_cache_requires_block
    assert_raises LocalJumpError do
      Busted.method_cache
    end
  end

  def test_constant_cache_requires_block
    assert_raises LocalJumpError do
      Busted.constant_cache
    end
  end

  def test_class_cache_requires_block
    assert_raises LocalJumpError do
      Busted.class_cache
    end
  end

  def test_cache_with_empty_block
    invalidations = Busted.cache { }
    assert_equal 0, invalidations[:method]
    assert_equal 0, invalidations[:constant]
    assert_equal 0, invalidations[:class]
  end

  def test_method_cache_with_empty_block
    assert_equal 0, Busted.method_cache { }
  end

  def test_constant_cache_with_empty_block
    assert_equal 0, Busted.constant_cache { }
  end

  def test_class_cache_with_empty_block
    assert_equal 0, Busted.class_cache { }
  end

  def test_cache_with_addition
    invalidations = Busted.cache { 1 + 1 }
    assert_equal 0, invalidations[:method]
    assert_equal 0, invalidations[:constant]
    assert_equal 0, invalidations[:class]
  end

  def test_method_cache_with_addition
    assert_equal 0, Busted.method_cache { 1 + 1 }
  end

  def test_constant_cache_with_addition
    assert_equal 0, Busted.constant_cache { 1 + 1 }
  end

  def test_class_cache_with_addition
    assert_equal 0, Busted.class_cache { 1 + 1 }
  end

  def test_cache_with_new_constant
    invalidations = Busted.cache do
      self.class.const_set :"CHEESE", "cheese"
    end
    assert_equal 0, invalidations[:method]
    assert invalidations[:constant] > 0
    assert_equal 0, invalidations[:class]
  end

  def test_method_cache_with_new_constant
    invalidations = Busted.method_cache do
      self.class.const_set :"HAWAIIAN", "hawaiian"
    end
    assert_equal 0, invalidations
  end

  def test_constant_cache_with_new_constant
    invalidations = Busted.constant_cache do
      self.class.const_set :"VEGETABLE", "vegetable"
    end
    assert_equal 1, invalidations
  end

  def test_class_cache_with_new_constant
    invalidations = Busted.class_cache do
      self.class.const_set :"SAUSAGE", "sausage"
    end
    assert_equal 0, invalidations
  end

  def test_cache_with_new_method
    invalidations = Busted.cache do
      Object.class_exec { def cheese; end }
    end
    assert invalidations[:method] > 0
    assert_equal 0, invalidations[:constant]
    assert_equal 0, invalidations[:class]
  end

  def test_method_cache_with_new_method
    invalidations = Busted.method_cache do
      Object.class_exec { def hawaiian; end }
    end
    assert invalidations > 0
  end

  def test_constant_cache_with_new_method
    invalidations = Busted.constant_cache do
      Object.class_exec { def vegetable; end }
    end
    assert_equal 0, invalidations
  end

  def test_class_cache_with_new_method
    invalidations = Busted.class_cache do
      Object.class_exec { def sausage; end }
    end
    assert_equal 0, invalidations
  end

  def test_cache_with_new_class
    invalidations = Busted.cache do
      Object.class_eval "class ThreeCheese; end"
    end
    assert_equal 0, invalidations[:method]
    assert_equal 1, invalidations[:constant]
    assert invalidations[:class] > 0
  end

  def test_method_cache_with_new_class
    invalidations = Busted.method_cache do
      Object.class_eval "class SweetHawaiian; end"
    end
    assert_equal 0, invalidations
  end

  def test_constant_cache_with_new_class
    invalidations = Busted.constant_cache do
      Object.class_eval "class Veggie; end"
    end
    assert_equal 1, invalidations
  end

  def test_class_cache_with_new_class
    invalidations = Busted.class_cache do
      Object.class_eval "class MeatLovers; end"
    end
    assert invalidations > 0
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

  def test_class_cache_predicate_requires_block
    assert_raises LocalJumpError do
      Busted.class_cache?
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

  def test_class_cache_predicate_with_empty_block
    refute Busted.class_cache? { }
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

  def test_class_cache_predicate_with_addition
    refute Busted.class_cache? { 1 + 1 }
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

  def test_class_cache_predicate_with_new_constant
    refute Busted.class_cache? { self.class.const_set :"WHEAT", "wheat" }
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

  def test_class_cache_predicate_with_new_method
    refute Busted.class_cache? { Object.class_exec { def wheat; end } }
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

  def test_class_cache_predicate_with_new_class
    assert Busted.class_cache? { Object.class_eval "class TStreetWheat; end" }
  end
end
