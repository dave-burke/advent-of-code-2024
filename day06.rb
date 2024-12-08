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

  def to_s
    "(#{@row},#{@col})"
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

class Point2
  def initialize(row, col, direction, rows)
    @row = row
    @col = col
    @direction = direction
    @rows = rows
  end

  attr_reader :row, :col
  attr_accessor :direction

  def value
    return nil if @row.negative? || @row > @rows.length || @col.negative? || @col > @rows[0].length

    @rows.dig(@row, @col)
  end

  def with_test_rows(rows)
    Point2.new(@row, @col, @direction, rows)
  end

  def turn(new_direction)
    Point2.new(@row, @col, new_direction, @rows)
  end

  def go
    new_row = @row + @direction.offset_row
    new_col = @col + @direction.offset_col
    Point2.new(new_row, new_col, @direction, @rows)
  end

  def to_s
    "{(#{@row},#{@col}) > #{@direction.name}}"
  end

  def hash
    [self.class, @row, @col, @direction].hash
  end

  def ==(other)
    eql? other
  end

  def eql?(other)
    self.class == other.class &&
      @row == other.row &&
      @col == other.col &&
      @direction == other.direction
  end
end

def traverse(cursor)
  current_direction = 0
  path = [cursor]
  unique_path = Set.new([cursor])
  until path[-1].value.nil?
    current_cursor = path[-1]
    new_cursor = current_cursor.go
    if new_cursor.value == '#'
      # hit a wall, turn
      current_cursor = path.pop
      unique_path.delete current_cursor

      current_direction = (current_direction + 1) % 4
      turned_cursor = current_cursor.turn(DIRECTIONS[current_direction])
      path.push turned_cursor
      unique_path.add turned_cursor
    else
      # no wall, just move along
      path.push new_cursor
      unique_path.add new_cursor
    end
    return [path, new_cursor] if path.length != unique_path.length
  end
  path.pop # remove nil value
  [path, nil]
end

def part2(input)
  rows = input.split("\n").map(&:chars)

  init_cursor = nil
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      if col == '^'
        init_cursor = Point2.new(r, c, DIRECTIONS[0], rows)
        break
      end
    end
    break unless init_cursor.nil?
  end
  puts "Found cursor at #{init_cursor.row} #{init_cursor.col}"

  path, = traverse(init_cursor)
  puts "Default path is #{path.length} spaces long"
  unique_path_points = Set.new(path.map { |point2| Point.new(point2.row, point2.col, rows) })
  puts "It contains #{path.length} unique points"

  cycle_count = 0
  unique_path_points.each_with_index do |path_point, i|
    next unless path_point.value == '.'

    print "Testing #{i}: (#{path_point.row},#{path_point.col})..."
    test_rows = rows.map(&:clone)
    test_rows[path_point.row][path_point.col] = '#'
    test_cursor = init_cursor.with_test_rows test_rows
    _, is_cycle = traverse(test_cursor)
    if is_cycle
      print "Found a cycle for #{path_point}"
      cycle_count += 1
    else
      print 'Left the board'
    end
    print " #{cycle_count}\n"
  end
  puts "Found #{cycle_count} cycles"
end

input = Aoc.download_input_if_needed(DAY)
# 16084 is too high
# 2229 is too high
part2(input)
