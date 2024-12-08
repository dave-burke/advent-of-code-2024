#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 7

def part1(input)
  lines = input.split("\n").map { |line| parse_line(line) }

  result = 0
  lines.each do |line|
    solutions = find_solutions(line)
    result += line.total unless solutions.empty?
  end
  puts "#{result}"
end

def find_solutions(line)
  ops = init_operators(line.nums)
  result = 0
  solutions = []
  until ops.nil?
    result = apply_ops(line.nums, ops)
    # puts "#{line} | #{ops} | #{result}"
    solutions.push(ops) if result == line.total
    ops = incr_ops(ops)
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
    if op == '+'
      result += num
    elsif op == '*'
      result *= num
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

def incr_ops(operators)
  # print operators
  as_binary = operators.map do |op|
    if op == '+'
      '0'
    elsif op == '*'
      '1'
    end
  end
  as_string = as_binary.join
  # print " > #{as_string}"
  length = as_string.length
  as_int = as_string.to_i(2)
  # print " > #{as_int}"
  next_int = as_int + 1
  # print " > #{next_int}"
  next_string = next_int.to_s(2)
  # print " > #{next_string}"
  next_string = next_string.rjust(length, '0')
  # print " > #{next_string}"
  next_ops = next_string.chars.map do |bit|
    if bit == '0'
      '+'
    elsif bit == '1'
      '*'
    end
  end
  return next_ops unless next_ops.length > operators.length

  nil
end

# (2**(n-1)) has n bits

##########################

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
