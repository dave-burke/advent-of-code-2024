#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'
require_relative 'point'

DAY = 15

LOG = Logger.new($stdout, Logger::INFO)
LOG.formatter = proc do |severity, datetime, _, msg|
  "#{datetime.strftime('%H:%M:%S')} #{severity.ljust(5)}: #{msg}\n"
end

class Point < BasePoint
  def wall?
    value == '#'
  end

  def crate?
    value == 'O'
  end

  def empty?
    value == '.'
  end

  def robot?
    value == '@'
  end

  def go(direction)
    new_row = @row + direction.offset_row
    new_col = @col + direction.offset_col
    Point.new(new_row, new_col, @rows)
  end

  attr_reader :rows
end

def direction(char)
  case char
  when '<'
    DIRECTIONS[:LEFT]
  when '^'
    DIRECTIONS[:UP]
  when '>'
    DIRECTIONS[:RIGHT]
  when 'v'
    DIRECTIONS[:DOWN]
  else
    raise "Invalid direction: '#{char}'"
  end
end

def search(point, direction, &block)
  point = point.go(direction) while !point.value.nil? && !block.call(point)
  point
end

def move(point, direction)
  destination = point.go(direction)
  return point if destination.wall?

  if destination.empty?
    destination.rows[destination.row][destination.col] = '@'
    destination.rows[point.row][point.col] = '.'
    return destination
  end

  if destination.crate?
    target = search(destination, direction) { !_1.crate? }
    return point if target.wall? || target.value.nil?

    destination.rows[destination.row][destination.col] = '@'
    destination.rows[point.row][point.col] = '.'
    destination.rows[target.row][target.col] = 'O'
    return destination
  end

  raise "Invalid point #{destination}"
end

def debug(rows)
  rows.each do |row|
    row.each do |col|
      print col
    end
    print "\n"
  end
  print "\n"
end

def gps(point)
  return 0 unless point.crate?

  point.row * 100 + point.col
end

def find_robot(rows)
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      return [r, c] if col == '@'
    end
  end
end

def part1(input)
  parts = input.split("\n\n")
  rows = parts[0].split("\n").map(&:chars)
  robot_location = find_robot(rows)
  robot = Point.new(robot_location[0], robot_location[1], rows)

  directions = parts[1].split("\n").join.strip

  # debug rows
  directions.chars.map { direction _1 }.each do |direction|
    # puts direction
    robot = move(robot, direction)
    # debug rows
  end

  result = 0
  robot.rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      result += gps(Point.new(r, c, rows))
    end
  end

  puts result
end

## A point in a wide grid
class Point2 < Point
  def crate?
    value == '[' || value == ']'
  end

  def crate
    if value == '['
      [self, go(DIRECTIONS[:RIGHT])]
    elsif value == ']'
      [go(DIRECTIONS[:LEFT]), self]
    else
      raise "Not a crate: #{self}"
    end
  end

  def go(direction)
    new_row = @row + direction.offset_row
    new_col = @col + direction.offset_col
    Point2.new(new_row, new_col, @rows)
  end
end

def expand(rows)
  expanded = []
  rows.each do |row|
    expanded_row = []
    row.each do |col|
      case col
      when '#', '.'
        expanded_row.push(col)
        expanded_row.push(col)
      when 'O'
        expanded_row.push('[')
        expanded_row.push(']')
      when '@'
        expanded_row.push '@'
        expanded_row.push '.'
      else
        raise "Invalid char #{col}"
      end
    end
    expanded.push expanded_row
  end
  expanded
end

def push_crate(crate, direction)
  if direction == DIRECTIONS[:LEFT] || direction == DIRECTIONS[:RIGHT]
    push_crate_horizontal(crate, direction)
  else
    push_crate_vertical(crate, direction)
  end
end

# Return nil if can't push, or moved crate if pushed
def push_crate_horizontal(crate, direction)
  raise "Got #{crate.map(&:to_s)} but #{direction} not implemented"
end

# Return nil if can't push, or moved crate if pushed
def push_crate_vertical(crate, direction)
  raise "Got #{crate} but #{direction} not implemented"
end

def move(point, direction)
  destination = point.go(direction)
  return point if destination.wall?

  if destination.empty?
    destination.rows[destination.row][destination.col] = '@'
    destination.rows[point.row][point.col] = '.'
    return destination
  end

  if destination.crate?
    crate = destination.crate
    push_result = push_crate(crate, direction)
    return point if push_result.nil?

    destination.rows[destination.row][destination.col] = '@'
    destination.rows[point.row][point.col] = '.'
    return destination
  end

  raise "Invalid point #{destination}"
end

def part2(input)
  parts = input.split("\n\n")
  rows = parts[0].split("\n").map(&:chars)
  rows = expand(rows)

  robot_location = find_robot(rows)
  robot = Point2.new(robot_location[0], robot_location[1], rows)

  directions = parts[1].split("\n").join.strip

  debug rows
  directions.chars.map { direction _1 }.each do |direction|
    puts direction
    robot = move(robot, direction)
    debug rows
  end

  result = 0
  robot.rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      result += gps(Point.new(r, c, rows))
    end
  end

  puts result
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
