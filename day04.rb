#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 4

def part1(input)
  lines = input.split("\n")
  puts "There were #{lines.size} lines"
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
