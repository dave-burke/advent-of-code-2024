# Strings

string = "Hello, world!"
string.length # 13 -- also .size
string.count("l") # 3
string.index(", ") # 5
string[5] # ,

string.include? "!" # true
string.start_with? "Hello" # true
string.end_with? "world!" # true

string.match? "\s" # true
string.scan("[aeiou]") # ['e', 'o', 'o'] -- can also use a block 'for each match'

string.gsub("l", "p") # Heppo, worpd! -- also sub for first only
string.delete("l") # heo word!
string.delete_prefix("He") # llo, world!
string.delete_suffix(", world!") # Hello

"   foo   ".strip # 'foo' -- also lstrip/rstrip
string.squeeze # helo, world!
string.tr "el" "ip" # hippo, worpd!


string.next # "Hello, worle!" also prev also .succ
"10".upto("20") { |num| puts num } # print 10-20; works with letters

string.split(", ") # ["Hello", "world!"]
"foo\nbar".lines # ['foo\n', 'bar']
string.each_char do |c| # also each_line
  print c
end

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

# Hashes

hash = { "spam" => "eggs", :pancakes => "syrup", spam: "eggs" }
puts hash.key?(:spam) # true
puts hash.value?("eggs") #true
hash.each do |key,value|
  puts key.to_s + ": " + value
end

# Classes

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

#Person.foo     #=> NoMethodError: undefined method `foo' for Person:Class
Person.new.foo #=> "foo"
Book.foo       #=> "foo"
#Book.new.foo   #=> NoMethodError: undefined method `foo'

