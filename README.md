# Busted  [![Build Status](https://travis-ci.org/simeonwillbanks/busted.png?branch=master)](https://travis-ci.org/simeonwillbanks/busted) [![Code Climate](https://codeclimate.com/github/simeonwillbanks/busted.png)](https://codeclimate.com/github/simeonwillbanks/busted)

### Find code that busts the Ruby 2.1+ cache.

**Busted** reports when code invalidates Ruby's internal cache.

- [Basic Usage](#basic-usage) reports cache invalidations
- [Advanced Usage](#advanced-usage) details exact invalidation locations via [`dtrace`](http://en.wikipedia.org/wiki/DTrace)
- [Coming Soon](https://github.com/simeonwillbanks/busted/issues/2) a Rails profiler for reporting cache invalidations per request
- **Busted** relies upon [RubyVM.stat](http://ruby-doc.org/core-2.1.0/RubyVM.html#method-c-stat) and the [ruby:::method-cache-clear](http://ruby-doc.org/core-2.1.0/doc/dtrace_probes_rdoc.html) `dtrace` probe

## Basic Usage

*Any Cache*

```ruby
Busted.cache? do
  class Beer
  end
end
#=> true

Busted.run do
  class Pizza
  end
end
#=> {:invalidations=>{:method=>0, :constant=>1}}

Busted.start
class Pie
end
Busted.finish
#=> {:invalidations=>{:method=>0, :constant=>1}}
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
#=> 1

Busted.run do
  def pie
  end
end
#=> {:invalidations=>{:method=>1, :constant=>0}}

Busted.start
def smoothie
end
Busted.finish
#=> {:invalidations=>{:method=>1, :constant=>0}}
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

Busted.run do
  PIE = "pumpkin"
end
#=> {:invalidations=>{:method=>0, :constant=>1}}

Busted.start
SMOOTHIE = "blueberry"
Busted.finish
#=> {:invalidations=>{:method=>0, :constant=>1}}
```

*No Cache Busted*

```ruby
Busted.cache? do
  beer = "beer"
end
#=> false

Busted.run do
  pizza = "pizza"
end
#=> {:invalidations=>{:method=>0, :constant=>0}}

Busted.start
pie = "pie"
Busted.finish
#=> {:invalidations=>{:method=>0, :constant=>0}}
```

## Advanced Usage
**Busted** can report method cache invalidation locations via [`dtrace`](http://en.wikipedia.org/wiki/DTrace). The running process must have root privileges, and `dtrace` must be installed.

*trace.rb*
```ruby
require "busted"
require "pp"

report = Busted.run(trace: true) do
  def cookie
  end
end
pp report
```

```bash
$ whoami
simeon

$ id simeon
uid=501(simeon) gid=20(staff) groups=20(staff),80(admin)

# simeon is an admin; sudo does not require a password
$ sudo grep admin /etc/sudoers
%admin	ALL=(ALL) NOPASSWD: ALL

$ sudo dtrace -V
dtrace: Sun D 1.6.2

# No need to sudo
# Busted runs dtrace in a child process with root privileges
$ ruby trace.rb
{:invalidations=>{:method=>1, :constant=>0},
 :traces=>
  {:method=>[{:class=>"global", :sourcefile=>"trace.rb", :lineno=>"5"}]}}
```

*start_finish_trace.rb*
```ruby
require "busted"
require "pp"

Busted.start trace: true
def ice_cream
end
pp Busted.finish
```

```bash
$ ruby start_finish_trace.rb
{:invalidations=>{:method=>1, :constant=>0},
 :traces=>
  {:method=>
    [{:class=>"global", :sourcefile=>"start_finish_trace.rb", :lineno=>"5"}]}}
```

**Busted** includes an [example `dtrace` probe](/dtrace/probes/examples/method-cache-clear.d) for use on the command line or an application.  See the [probe](/dtrace/probes/examples/method-cache-clear.d) for usage.

## Installation

***Requires MRI Ruby 2.1+***

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
