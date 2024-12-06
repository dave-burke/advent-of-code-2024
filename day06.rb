#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 6

## Represents a direction to move
class Direction
  def initialize(name, offset_row, offset_col)
    @name = name
    @offset_row = offset_row
    @offset_col = offset_col
  end

  attr_reader :name, :offset_row, :offset_col
end

DIRECTIONS = [
  Direction.new('UP', -1, 0),
  Direction.new('RIGHT', 0, 1),
  Direction.new('DOWN', 1, 0),
  Direction.new('LEFT', 0, -1)
].freeze

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

  def hash
    [self.class, @row, @col].hash
  end

  def ==(other)
    eql? other
  end

  def eql?(other)
    self.class == other.class &&
      @row == other.row &&
      @col == other.col
  end
end

def part1(input)
  rows = input.split("\n").map(&:chars)

  init_cursor = nil
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      init_cursor = Point.new(r, c, rows) if col == '^'
    end
  end
  puts "Found cursor at #{init_cursor.row} #{init_cursor.col}"

  current_direction = 0
  path = [init_cursor]
  until path[-1].value.nil?
    new_cursor = path[-1].go(DIRECTIONS[current_direction])
    puts "Attempting to move to (#{new_cursor.row}, #{new_cursor.col}) = #{new_cursor.value}"
    if new_cursor.value == '#'
      current_direction = (current_direction + 1) % 4
      puts "Hit a wall, new direction is #{DIRECTIONS[current_direction].name}"
    elsif new_cursor.value.nil?
      puts 'Moved off the grid'
      path.push new_cursor
    else
      puts "Moved to #{new_cursor.row}, #{new_cursor.col}"
      path.push new_cursor
    end
  end
  path.pop # remove nill entry

  puts "Left the area in #{path.length} points"

  distinct = Set.new(path)

  puts "That is, #{distinct.size} distinct points"
end

def part2(input)
  puts input.length
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
