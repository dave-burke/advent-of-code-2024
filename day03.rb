#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 3

def part1(input)
  matches = input.scan(/mul\((\d+),(\d+)\)/)
  puts matches
    .map { |match| match.map(&:to_i) }
    .map { |numbers| numbers[0] * numbers[1] }
    .sum
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
