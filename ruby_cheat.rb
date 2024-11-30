# frozen_string_literal: true

# Strings

string = 'Hello, world!'
string.length # 13 -- also .size
string.count('l') # 3
string.index(', ') # 5
string[5] # ,

string.include? '!' # true
string.start_with? 'Hello' # true
string.end_with? 'world!' # true

string.match? "\s" # true
string.scan('[aeiou]') # ['e', 'o', 'o'] -- can also use a block 'for each match'

string.gsub('l', 'p') # Heppo, worpd! -- also sub for first only
string.delete('l') # heo word!
string.delete_prefix('He') # llo, world!
string.delete_suffix(', world!') # Hello

'   foo   '.strip # 'foo' -- also lstrip/rstrip
string.squeeze # helo, world!
string.tr 'el', 'ip' # hippo, worpd!

string.next # "Hello, worle!" also prev also .succ
'10'.upto('20') { |num| puts num } # print 10-20; works with letters

string.split(', ') # ["Hello", "world!"]
"foo\nbar".lines # ['foo\n', 'bar']
string.each_char do |c| # also each_line
  print c
end
print "\n"

# Regex
/world/.match? 'Hello, world!' # true
match_data = %r|(\d{2})/(\d{2})/(\d{4})|.match('04/05/2063') # use (?<name>...) for named captures match_data[:year]
_, day, month, year = match_data.to_a # need to_a to make it an array for destructuring
puts "ISO: #{year}-#{month}-#{day}"
/o+?/.match 'foobar' # 'o' (lazy -- /o+/ would match 'oo')
'Hello, world!'.scan(/[aeiou]/) # ["e", "o", "o"]

# Dates
require('date')

start = Date.new(1985, 10, 25)
middle = Date.parse('1955-11-05')
finish = Date.strptime('10/21/2015', '%m/%d/%Y')
puts start, middle, finish
start.leap?
puts middle.upto(finish).to_a.size

# Sets
require 'set'
s1 = Set[1, 2] #=> #<Set: {1, 2}>
s1.each { |n| puts n }
s1.empty? # false
s1.include? 1 # true
s2 = [1, 2].to_set #=> #<Set: {1, 2}>
s2.classify { |n| (n % 2).zero? } # { false => Set[1], true => Set[2]}
s2.map { |n| n * 2 } # Set[2,4]
puts Set[1, 2] + Set[3, 4] # Set[1,2,3,4]
puts s1 == s2 #=> true
s1.add('foo') #=> #<Set: {1, 2, "foo"}>
s1.merge([2, 6]) #=> #<Set: {1, 2, "foo", 6}>
s1.delete 2 # Set{1}
s2.delete_if { |n| (n % 2).zero? } # Set[1]
s2.keep_if { |n| (n % 2).zero? } # Set[2]
s2.subset?(s1) #=> true
s2.superset?(s1) #=> true
Set[1, 2].disjoint? Set[3, 4] # true -- they have nothing in common
Set[1, 2, 3].intersect? Set[3, 4, 5] # true -- they have one in common
puts Set[1, 2, 3, 4] - Set[1, 2] # Set[3,4]

# Arrays

arr = [1, 2, 3]
arr << 4 # append
puts arr.first + arr[1] + arr[-1]
arr[2, 1] << arr[2..3] # [start, length] or [range]
[1, 2, 3].delete(1) # returns 1, modifies array to [2,3] -- also delete_if or delete_at
arr.filter { (_1 % 2).zero? } # [2]
arr.reject { (_1 % 2).zero? } # [1,3]
arr.drop(2) # [3] -- also drop_while, take, take_while
[1, nil, 2].compact # [1, 2] (remove nil)
[1, 1, 2].uniq # [1, 2]
%w[a b c d e f].values_at(1, 3, -1) # [b, d, f]
arr.fetch(4, 'default value') # "default value" because arr.length is 3 -- can be called with a block
[[1, [2, 3]]].dig(0, 1, 1) # 3
arr.reverse unless arr.empty? # reverse! would work in-place
arr.min # 1 -- can pass a block comparator. also max and minmax
arr.sum # 6
arr.join('+') unless arr.empty?
arr.map { _1 * 2 } # [2, 4, 6]
arr.combination(2) # [[1, 2], [1, 3], [2, 3]]
arr.repeated_combination(2) # [[1, 2], [1, 2], [1, 3], [2, 2], [2, 3], [3, 3]]
arr.permutation(2) # [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]
[1, 2].product([3, 4], [5, 6]) #=> [[1,3,5],[1,3,6],[1,4,5],[1,4,6],[2,3,5],[2,3,6],[2,4,5],[2,4,6]]
arr.count(2) # 1 -- can also pass a block, or nothing to get length
arr.cycle(2) { puts _1 } # 1,2,3,1,2,3 (with no num would cycle forever)
arr.rotate # [2, 3, 1] -- accepts an optional count
[[1, 2], [3, 4], [5, 6]].transpose # [[1,3,5],[2,4,6]] or zip (won't fail on length mismatch and handles any enumerable)
arr.include? 2 # true
arr.each { puts _1 }
arr.all? { (_1 % 2).zero? } # false
arr.any? { (_1 % 2).zero? } # true
arr.none? { _1 > 4 } # true
[%w[a b], %w[c d], %w[e f]].assoc('d') # ['c','d']
arr.bsearch { _1 == 2 } # 2 (binary search--array must be sorted

def double(num)
  num * 2
end
puts(arr.map { |x| double(x) })

def sum(*nums)
  nums.reduce(&:+)
end
puts sum(arr)

# Hashes

hash = { 'spam' => 'eggs', :pancakes => 'syrup', spam: 'eggs' }
puts hash.key?(:spam) # true
puts hash.value?('eggs') # true
hash.each do |key, value|
  puts "#{key}: #{value}"
end

# Classes

##
# Demo class
class SomeData
  # using 1 '@' symbol makes it unavailable to subclasses
  @class_variable = 'Like public static final'
  MY_CONSTANT = 'constant variables start with a capital letter'

  def initialize(foo, bar = 'baz')
    # Instance variables
    @foo = foo
    @bar = bar
  end

  attr_accessor :foo # shorthand for getter and setter
  attr_writer :bar # shorthand for just setter; attr_reader for getter

  def self.static_method
    'Callable via SomeData.static_method(), not on an instance'
  end
end

instance = SomeData.new('hi')
puts instance.foo + SomeData.static_method + SomeData::MY_CONSTANT

##
# Example module
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

# Person.foo     #=> NoMethodError: undefined method `foo' for Person:Class
Person.new.foo #=> "foo"
Book.foo       #=> "foo"
# Book.new.foo   #=> NoMethodError: undefined method `foo'
