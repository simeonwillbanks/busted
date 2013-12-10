# Busted

***Requires MRI Ruby 2.1.0dev***

Find code that busts the Ruby cache.

- Report when code invalidates Ruby's internal cache
- Uses [RubyVM.stat](https://github.com/ruby/ruby/commit/cc1063092b366a0a8449528ab6bf67a72f5ce027)

## Usage

*Any Cache*

```ruby
Busted.cache? do
  class Beer
  end
end
#=> true

Busted.cache_invalidations do
  class Pizza
  end
end
#=> {:method=>0, :constant=>1, :class=>2}
```

*Method Cache*

```ruby
Busted.method_cache? do
  def beer
  end
end
#=> true

Busted.method_cache_invalidations do
  def pizza
  end
end
#=> 3
```

*Constant Cache*

```ruby
Busted.constant_cache? do
  STOUT = "stout"
end
#=> true

Busted.constant_cache_invalidations do
  CHEESE = "cheese"
end
#=> 1
```

*Class Cache*

```ruby
Busted.class_cache? do
  class Porter
  end
end
#=> true

Busted.class_cache_invalidations do
  class Veggie
  end
end
#=> 2
```

*No Cache Busted*

```ruby
Busted.cache? do
  beer = "beer"
end
#=> false

Busted.cache_invalidations do
  pizza = "pizza"
end
#=> {:method=>0, :constant=>0, :class=>0}
```

## Installation

***Requires MRI Ruby 2.1.0dev***

Add this line to your application's Gemfile:

    gem "busted"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install busted

## Contributing

Check out [this guide](/CONTRIBUTING.md) if you'd like to contribute.

## License

This project is licensed under the [MIT License](/LICENSE.txt).

## Standing On The Shoulders Of Giants
A big *thank you* to [Charlie Somerville](https://github.com/charliesome) and [Aman Gupta](https://github.com/tmm1) for helping flesh out `RubyVM.stat` and committing it to Ruby core!
