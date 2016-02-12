# JsonData
[![Code Climate](https://codeclimate.com/github/jayjzheng/json_data/badges/gpa.svg)](https://codeclimate.com/github/jayjzheng/json_data)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_data

## Usage

### Basic Usage
```ruby
require 'json_data'

class MyClass
  include JSONData::Data

  data_attr :foo
end

data_source = JSON.generate(foo: 'bar') # or { foo: 'bar' }

my_class = MyClass.new(data_source: data_source)
my_class.foo # => 'bar'

my_class = MyClass.new
my_class.data_source = data_source
my_class.foo # => 'bar'
```

### Field Mapping
```ruby
class MyClass
  include JSONData::Data

  data_attr :foo, as: :bar
end

data_source = JSON.generate(foo: 'qux')

my_class = MyClass.new(data_source: data_source)
my_class.bar # => 'qux'
```

### Map to Ather JSONDAta Class
```ruby
class Class1
  include JSONData::Data

  data_attr :foo
end

class Class2
  include JSONData::Data

  data_attr :bar, data_class: Class1
end

data_source = JSON.generate(bar: {foo: 'qux'})

class2 = Class2.new(data_source: data_source)
class2.bar # => <Class1>
class2.bar.foo # => 'qux'
```

### Required Field
```ruby
class MyClass
  include JSONData::Data

  data_attr :foo, required: true
end

data_source = JSON.generate(foo: nil)

my_class = MyClass.new(data_source: data_source)

my_class.foo # => nil
my_class.valid? # => false
```

### Data Collection
```ruby
class MyClass
  include JSONData::Data

  data_attr :foo
end

class Collection
  include JSONData::Collection

  data_class MyClass
end

data_source = JSON.generate([{foo: 'bar'}, {foo: 'qux'}]) # or [{foo: 'bar'}, {foo: 'qux'}]

collection = Collection.new(data_source: data_source)

collection.count # => 2
collection.map(&:class) # => [ MyClass, MyClass ]
collection.map(&:foo) # => [ "bar", "qux" ]
```

### Data Collection Custom Formatter
```ruby
class MyClass
  include JSONData::Data

  data_attr :foo
  data_attr :id
end

class Collection
  include JSONData::Collection

  formatter = lambda do |raw|
    raw.map do |id, value|
      value[:id] = id
      value
    end
  end

  data_class MyClass, formatter: formatter
end

data_source = JSON.generate('111' => {foo: 'bar'}, '222' => {foo: 'qux'})

collection = Collection.new(data_source: data_source)

collection.map(&:foo) # => [ "bar", "qux" ]
collection.map(&:id) # =>  [ "111", "222" ]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jayjzheng/json_data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

