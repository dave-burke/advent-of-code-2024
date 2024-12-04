#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 4

XMAS = 'XMAS'

## Represents a direction to move
class Direction
  def initialize(name, offset_row, offset_col)
    @name = name
    @offset_row = offset_row
    @offset_col = offset_col
  end

  attr_reader :name, :offset_row, :offset_col
end

DIRECTIONS = {
  up_left: Direction.new('UP_LEFT', -1, -1),
  up: Direction.new('UP', -1, 0),
  up_right: Direction.new('UP_RIGHT', -1, 1),
  left: Direction.new('LEFT', 0, -1),
  right: Direction.new('RIGHT', 0, 1),
  down_left: Direction.new('DOWN_LEFT', 1, -1),
  down: Direction.new('DOWN', 1, 0),
  down_right: Direction.new('DOWN_RIGHT', 1, 1)
}.freeze

## Represents a point on the grid
class Point
  def initialize(row, col, rows)
    @row = row
    @col = col
    @rows = rows
  end

  attr_reader :row, :col

  def value
    return nil if @row.negative? || @row > @rows.length || @col.negative? || @col > @rows[0].length

    @rows.dig(@row, @col)
  end

  def go(direction)
    new_row = @row + direction.offset_row
    new_col = @col + direction.offset_col
    Point.new(new_row, new_col, @rows)
  end
end

def search(point, direction)
  return 0 if point.value != XMAS[0]

  print("# #{point.row}, #{point.col} #{direction.name} => ")
  XMAS.chars.each do |letter|
    if point.value != letter
      print " | No match for #{letter}. Got #{point.value}\n"
      return 0
    end

    print letter
    point = point.go(direction)
  end
  print "\n"

  1
end

def part1(input)
  lines = input.split("\n")
  rows = lines.map(&:chars)

  result = 0
  rows.each_with_index do |row, row_i|
    row.each_with_index do |_, col_i|
      point = Point.new(row_i, col_i, rows)
      DIRECTIONS.each_value do |direction|
        result += search(point, direction)
      end
    end
  end
  puts result
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
