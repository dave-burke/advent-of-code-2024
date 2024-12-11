#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 11

def blink(stones)
  result = []
  stones.each do |stone|
    if stone.zero?
      result.push(1)
      next
    end

    as_string = stone.to_s
    len = as_string.length
    if len.even?
      half = len / 2
      result.push(as_string[0, half].to_i)
      result.push(as_string[half..].to_i)
    else
      result.push(stone * 2024)
    end
  end
  result
end

def part1(input)
  stones = input.split.map(&:to_i)

  (0..24).each do |i|
    # puts "#{i}: #{stones}"
    stones = blink(stones)
  end
  # p stones
  p stones.length
end

def blink_recursive(stone, i, stop_i)
  return 1 if i == stop_i

  return blink_recursive(1, i + 1, stop_i) if stone.zero?

  as_string = stone.to_s
  len = as_string.length
  if len.even?
    half = len / 2
    first = as_string[0, half].to_i
    second = as_string[half..].to_i
    total = blink_recursive(first, i + 1, stop_i)
    total += blink_recursive(second, i + 1, stop_i)
    return total
  end

  blink_recursive(stone * 2024, i + 1, stop_i)
end

## Represents a stone
class Stone
  def initialize(value, iteration, index)
    @value = value
    @iteration = iteration
    @index = index
  end

  attr_reader :value, :iteration, :index

  def to_s
    @value
  end

  def id
    "#{value},#{iteration}"
  end
end

def iterate(stone, memo)
  return [Stone.new(1, stone.iteration + 1, stone.index)] if stone.value.zero?

  as_string = stone.value.to_s
  len = as_string.length
  if len.even?
    half = len / 2
    first = Stone.new(as_string[0, half].to_i, stone.iteration + 1, stone.index)
    second = Stone.new(as_string[half..].to_i, stone.iteration + 1, stone.index)
    return [first, second]
  end

  Stone.new(stone.value * 2024, stone.iteration + 1, stone.index)
end

def part2(input)
  values = input.split.map(&:to_i)

  stones = []
  values.each_with_index do |value, i|
    stones.push(Stone.new(value, 0, i))
  end

  stop_at = 25

  result = 0
  cur_index = stones[-1].index
  until stones.empty?
    stone = stones.pop
    if stone.index != cur_index
      cur_index = stone.index
      # puts cur_index
    end
    if stone.iteration >= stop_at
      result += 1
    else
      stones.push(*iterate(stone))
    end
  end
  puts result
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
