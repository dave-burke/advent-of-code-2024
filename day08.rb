#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 8

def part1(input)
  rows = input.split("\n").map { |line| line.split('') }

  char_points = {}
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      next if col == '.'

      char_points[col] = [] unless char_points.key?(col)
      char_points[col].push([r, c])
    end
  end

  char_points.each do |char, points|
    puts "Combinations of #{char}:"
    points.combination(2).each do |pair|
      puts "#{pair}"
    end
  end

  # puts char_points
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
