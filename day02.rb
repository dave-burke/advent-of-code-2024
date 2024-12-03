# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

input = Aoc.download_input_if_needed(2)

def parse_numbers(line)
  line.split.map(&:to_i)
end

lines = input.split("\n")

safe_count = 0
unsafe_count = 0

lines.each do |line|
  numbers = parse_numbers line

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
