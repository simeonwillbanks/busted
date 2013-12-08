# Busted

***Requires MRI Ruby 2.1.0dev***

Find code that busts the Ruby cache.

- Report when code invalidates Ruby's internal cache
- Uses [RubyVM.stat](https://github.com/ruby/ruby/commit/cc1063092b366a0a8449528ab6bf67a72f5ce027)

## Usage

*Any Cache*

```ruby
Busted.cache? do
  class Pizza
  end
end
#=> true
```

*Method Cache*

```ruby
Busted.method_cache? do
  def pizza
  end
end
#=> true
```

*Constant Cache*

```ruby
Busted.constant_cache? do
  PIZZA = "pizza"
end
#=> true
```

*Class Cache*

```ruby
Busted.class_cache? do
  class Beer
  end
end
#=> true
```

*No Cache Busted*

```ruby
Busted.cache? do
  beer = "beer"
end
#=> false
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
