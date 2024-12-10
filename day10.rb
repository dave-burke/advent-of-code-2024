#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 10

## Represents a point on the grid
class Point
  def initialize(row, col, rows)
    @row = row
    @col = col
    @rows = rows
  end

  attr_reader :row, :col, :rows

  def value
    rows[@row][@col].to_i
  end

  def to_s
    "(#{@row}, #{@col}) = #{value}"
  end

  def paths
    possible_paths = [
      Point.new(@row - 1, @col, rows), # up
      Point.new(@row, @col + 1, rows), # right
      Point.new(@row + 1, @col, rows), # down
      Point.new(@row, @col - 1, rows)  # right
    ]
    # remove out of bounds paths
    possible_paths.filter do |path|
      path.row >= 0 && path.row < rows.length &&
        path.col >= 0 && path.col < rows[0].length
    end
  end
end

def find_trailheads(rows)
  trailheads = []
  rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      point = Point.new(r, c, rows)
      trailheads.push(point) if point.value.zero?
    end
  end
  trailheads
end

def part1(input)
  rows = input.split("\n").map(&:chars)

  trailheads = find_trailheads(rows)

  puts "Trailheads: #{trailheads.map(&:to_s)}"

  puts rows.map(&:join)
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
