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

def part2(input)
  stones = input.split.map(&:to_i)

  (0..75).each do |i|
    puts i
    stones = blink(stones)
  end
  # p stones
  p stones.length
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
