# Arrays
arr = [1, 2, 3]
arr << 4 # append
puts arr.first + arr[1] + arr[-1]
puts arr[2,1] << arr[2..3] # [start, length] or [range]
puts arr.reverse if !arr.empty? # reverse! would work in-place
puts arr.join("+") unless arr.empty?
arr.each do |it|
  puts it
end

def double(x)
  x * 2
end
puts (arr.map do |x| double(x) end)

def sum(*nums)
  nums.reduce(&:+)
end
puts sum(arr)

hash = { "spam" => "eggs", :pancakes => "syrup", spam: "eggs" }
puts hash.key?(:spam) # true
puts hash.value?("eggs") #true
hash.each do |key,value|
  puts key.to_s + ": " + value
end

class SomeData

  # using 1 '@' symbol makes it unavailable to subclasses
  @@class_variable = "Like public static final"
  MyConstant = "constant variables start with a capital letter"

  def initialize(foo, bar="baz")
    # Instance variables
    @foo = foo
    @bar = bar
  end
  
  # Getter
  def foo()
    @foo
  end

  # Setter
  def foo=(foo)
    @foo = foo
  end

  attr_accessor :foo # shorthand for getter and setter
  attr_reader :MyConstant # shorthand for just getter
  attr_writer :bar # shorthand for just setter

  def self.static_method
    "Callable via SomeData.static_method(), not on an instance"
  end

end

instance = SomeData.new("hi")
puts instance.foo + SomeData.static_method() + SomeData::MyConstant

module ModuleExample
  def foo
    'foo'
  end
end

# Including modules binds their methods to the class instances.
class Person
  include ModuleExample
end

# Extending modules binds their methods to the class itself.
class Book
  extend ModuleExample
end

Person.foo     #=> NoMethodError: undefined method `foo' for Person:Class
Person.new.foo #=> "foo"
Book.foo       #=> "foo"
Book.new.foo   #=> NoMethodError: undefined method `foo'

