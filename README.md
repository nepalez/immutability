Immutability
============

[![Gem Version](https://img.shields.io/gem/v/immutability.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/immutability/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/immutability.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/immutability.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/immutability.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/immutability.svg)][inch]

Makes instances immutable (deeply frozen) and versioned.

Preamble
--------

The project is a clone of the [aversion][aversion] gem by [Josep M. Bach][txus] with some implementation differencies:

- it uses [ice_nine][ice_nine] gem to freeze instances deeply.
- instead of storing procedures that changed the instance, it stores reference to the previous state and the number of current version.

This approach to object's identity as a sequence of immutable snapshots is heavily inspired by 2009 year's brilliant talk ["Are We There Yet?"][are_we_there_yet] by [Rich Hickey][richhickey].

Synopsis
--------

### Immutable objects without memory:

Include the `Immutability` module to make the object immutable (deeply frozen).

```ruby
require "immutability"

class User
  include Immutability

  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age  = 44
  end
end

young_andrew = User.new "Andrew", 44
young_andrew.name         #  => "Andrew"
young_andrew.age          #  => 44

# The instance is frozen deeply:
young_andrew.frozen?      #  => true
young_andrew.name.frozen? #  => true
young_andrew.age.frozen?  #  => true
```

Use `update` with a block to create a **new instance** with updated values (other instance values remains the same):

```ruby
elder_andrew = young_andrew.update { @age = 45 }
elder_andrew.name         #  => "Andrew"
elder_andrew.age          #  => 45

# The instance is frozen deeply:
elder_andrew.frozen?      #  => true
elder_andrew.name.frozen? #  => true
elder_andrew.age.frozen?  #  => true
```

### Immutable objects with memory

Include `Immutability.with_memory` module to add `version` and `parent`:

```ruby
require "immutability"

class User
  include Immutability.with_memory

  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age  = 44
  end
end

young_andrew = User.new "Andrew", 44
young_andrew.name         #  => "Andrew"
young_andrew.age          #  => 44

# The instance is frozen as well:
young_andrew.frozen?      #  => true
young_andrew.name.frozen? #  => true
young_andrew.age.frozen?  #  => true

# Now it is versioned:
young_andrew.version      # => 0
young_andrew.parent       # => nil
```

The method `update` stores reference to the `#parent` and increases `#version`:

```ruby
elder_andrew = young_andrew.update { @age = 45 }
elder_andrew.name    #  => "Andrew"
elder_andrew.age     #  => 45

# Version is updated:
elder_andrew.version # => 1
elder_andrew.parent.equal? young_andrew # => true
```

Notice, than no instances in the sequence can be garbage collected (they still refer to each other).

Use `#forget_history` methods to reset version and free old instances for GC:

```ruby
reborn_andrew = elder_andrew.forget_history
reborn_andrew.name # => "Andrew"
reborn_andrew.age  # => 45

# History is forgotten
reborn_andrew.version # => 0
reborn_andrew.parent  # => nil
```

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "immutability"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install immutability
```

Compatibility
-------------

Tested under rubies [compatible to MRI 1.9+](.travis.yml).

Uses [RSpec][rspec] 3.0+ for testing and [hexx-suit][suit] for dev/test tools collection.

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/immutability)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Run `rake mutant` or `rake exhort` to ensure 100% [mutant-proof][mutant] coverage
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).

[are_we_there_yet]: http://www.infoq.com/presentations/Are-We-There-Yet-Rich-Hickey
[aversion]: https://github.com/txus/aversion
[codeclimate]: https://codeclimate.com/github/nepalez/immutability
[coveralls]: https://coveralls.io/r/nepalez/immutability
[gem]: https://rubygems.org/gems/immutability
[gemnasium]: https://gemnasium.com/nepalez/immutability
[ice_nine]: https://github.com/dkubb/ice_nine
[inch]: https://inch-ci.org/github/nepalez/immutability
[mutant]: https://github.com/mbj/mutant
[richhickey]: http://github.com/richhickey
[rspec]: http://rspec.org
[suit]: https://github.com/nepalez/hexx-suit
[travis]: https://travis-ci.org/nepalez/immutability
[txus]: https://github.com/txus
