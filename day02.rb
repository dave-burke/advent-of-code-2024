#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

def part1(input)
  lines = input.split("\n")
  safe_count = 0
  unsafe_count = 0

  lines.each do |line|
    numbers = line.split.map(&:to_i)

    prev_diff = nil
    safe = true
    numbers.each_with_index do |a, i|
      b = numbers[i + 1]
      break if b.nil?

      diff = (a - b)

      if diff.abs < 1 || diff.abs > 3
        safe = false
        unsafe_count += 1
        puts "#{numbers} is not safe because it has too big a jump"
        break
      end

      if !prev_diff.nil? && diff.positive? != (prev_diff.positive?)
        safe = false
        unsafe_count += 1
        puts "#{numbers} is not safe because it changes a polarity"
        break
      end
      prev_diff = diff
    end
    if safe
      puts "#{numbers} is safe"
      safe_count += 1
    end
  end

  puts "There were #{safe_count} safe lines"
  puts "There were #{unsafe_count} unsafe lines"
end

def safe_level?(first, second, is_increasing)
  diff = second - first

  return false if diff.abs < 1 || diff.abs > 3

  return false if diff.positive? != is_increasing

  true
end

def safe_line?(numbers)
  prev_value = nil
  is_increasing = numbers[-1] > numbers[0]

  numbers.each do |cur_value|
    if prev_value.nil?
      prev_value = cur_value
      next
    end
    return false unless safe_level? prev_value, cur_value, is_increasing

    prev_value = cur_value
  end
  true
end

def part2(input)
  lines = input.split("\n")
  safe_line_count = 0
  unsafe_line_count = 0

  lines.each do |line|
    numbers = line.split.map(&:to_i)

    print "#{numbers}"

    if safe_line? numbers
      print " -- Safe as-is\n"
      safe_line_count += 1
    else
      safe_with_dampener = false
      numbers.each_with_index do |n, i|
        test = numbers.dup
        test.delete_at(i)
        next unless safe_line? test

        print " -- Safe if you remove #{n} at #{i}\n"
        safe_with_dampener = true
        break
      end
      if safe_with_dampener
        safe_line_count += 1
      else
        print " -- not safe\n"
        unsafe_line_count += 1
      end
    end
  end

  # 329 is too low
  puts "There were #{safe_line_count} safe lines"
  puts "There were #{unsafe_line_count} unsafe lines"
end

input = Aoc.download_input_if_needed(2)
part2(input)
