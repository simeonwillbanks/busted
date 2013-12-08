require "test_helper"

class BustedTest < MiniTest::Unit::TestCase
  def test_responds_to_cache?
    assert Busted.respond_to? :cache?
  end

  def test_responds_to_method_cache?
    assert Busted.respond_to? :method_cache?
  end

  def test_responds_to_constant_cache?
    assert Busted.respond_to? :constant_cache?
  end

  def test_block_required
    assert_raises LocalJumpError do
      Busted.cache?
    end
  end

  def test_empty_block
    refute Busted.cache? { }
    refute Busted.method_cache? { }
    refute Busted.constant_cache? { }
  end

  def test_cache_with_addition
    refute Busted.cache? { 1 + 1 }
  end

  def test_method_cache_with_addition
    refute Busted.method_cache? { 1 + 1 }
  end

  def test_constant_cache_with_addition
    refute Busted.constant_cache? { 1 + 1 }
  end

  def test_class_cache_with_addition
    refute Busted.class_cache? { 1 + 1 }
  end

  def test_cache_with_new_constant
    assert Busted.cache? { self.class.const_set :"FOO", "foo"  }
  end

  def test_method_cache_with_new_constant
    refute Busted.method_cache? { self.class.const_set :"BAR", "bar"  }
  end

  def test_constant_cache_with_new_constant
    assert Busted.constant_cache? { self.class.const_set :"BAZ", "baz"  }
  end

  def test_class_cache_with_new_constant
    refute Busted.class_cache? { self.class.const_set :"BEER", "beer"  }
  end

  def test_cache_with_new_method
    assert Busted.cache? { Object.class_exec { def foo; end } }
  end

  def test_method_cache_with_new_method
    assert Busted.method_cache? { Object.class_exec { def bar; end } }
  end

  def test_constant_cache_with_new_method
    refute Busted.constant_cache? { Object.class_exec { def baz; end } }
  end

  def test_class_cache_with_new_method
    refute Busted.class_cache? { Object.class_exec { def beer; end } }
  end

  def test_cache_with_new_class
    assert Busted.cache? { Object.class_eval %q{class PierRatPorter; end} }
  end

  def test_method_cache_with_new_class
    refute Busted.method_cache? { Object.class_eval %q{class MidnightExpression; end} }
  end

  def test_constant_cache_with_new_class
    assert Busted.constant_cache? { Object.class_eval %q{class SantasLittleHelper; end} }
  end

  def test_class_cache_with_new_class
    assert Busted.class_cache? { Object.class_eval %q{class TStreetWheat; end} }
  end
end
