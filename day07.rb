#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 7

BIT_TO_OP = {
  0 => '+',
  1 => '*',
  2 => '|'
}.freeze
OP_TO_BIT = BIT_TO_OP.invert

def part1(input)
  lines = input.split("\n").map { |line| parse_line(line) }

  result = 0
  lines.each do |line|
    solutions = find_solutions(line)
    result += line.total unless solutions.empty?
  end
  puts "#{result}"
end

def find_solutions(line, base = 2)
  ops = init_operators(line.nums)
  solutions = []
  until ops.nil?
    result = apply_ops(line.nums, ops)
    # puts "#{line} | #{ops} | #{result}"
    solutions.push(ops) if result == line.total
    ops = incr_ops(ops, base)
  end
  solutions
end

def apply_ops(nums, ops)
  private_ops = ops.dup
  private_nums = nums.dup
  result = private_nums.shift
  until private_ops.empty?
    op = private_ops.shift
    num = private_nums.shift
    case op
    when '+'
      result += num
    when '*'
      result *= num
    when '|'
      result = (result.to_s + num.to_s).to_i
    end
  end
  result
end

def parse_line(line)
  total, num_list = line.split(':')
  nums = num_list.split(' ').map(&:to_i)
  Equation.new(total.to_i, nums)
end

## Represents an equation without operators
class Equation
  def initialize(total, nums)
    @total = total
    @nums = nums
  end

  attr_reader :total, :nums

  def to_s
    "#{@total}: #{nums}"
  end
end

def init_operators(nums)
  result = []
  (0..nums.length - 2).each { |_| result.push '+' }
  result
end

def incr_ops(operators, base = 2)
  # print operators
  as_binary = operators.map do |op|
    OP_TO_BIT[op]
  end
  as_string = as_binary.join
  # print " > #{as_string}"
  length = as_string.length
  as_int = as_string.to_i(base)
  # print " > #{as_int}"
  next_int = as_int + 1
  # print " > #{next_int}"
  next_string = next_int.to_s(base)
  # print " > #{next_string}"
  next_string = next_string.rjust(length, '0')
  # print " > #{next_string}"
  next_ops = next_string.chars.map do |bit|
    BIT_TO_OP[bit.to_i]
  end
  return next_ops unless next_ops.length > operators.length

  nil
end

# (2**(n-1)) has n bits

##########################

def part2(input)
  lines = input.split("\n").map { |line| parse_line(line) }

  result = 0
  lines.each_with_index do |line, i|
    print "Line #{i}/850: "
    solutions = find_solutions(line, 3)
    result += line.total unless solutions.empty?
    print "#{solutions.length}\n"
  end
  puts "#{result}"
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
