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

def wall?(grid, point)
  grid.value(point) == '#'
end

def crate?(grid, point)
  ['O', '[', ']'].include? grid.value(point)
end

def empty?(grid, point)
  grid.value(point) == '.'
end

def robot?(grid, point)
  grid.value(point) == '@'
end

def char_to_direction(char)
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

def search(grid, point, direction, &block)
  point = point.go(direction) while !grid.value(point).nil? && !block.call(point)
  point
end

def move(grid, point, direction)
  destination = point.go(direction)
  return [grid, point] if wall?(grid, destination)

  if empty?(grid, destination)
    grid = grid.update do |rows|
      rows[destination.row][destination.col] = '@'
      rows[point.row][point.col] = '.'
    end
    return [grid, destination]
  end

  if crate?(grid, destination)
    target = search(grid, destination, direction) { !crate?(grid, _1) }
    return [grid, point] if wall?(grid, target) || grid.value(target).nil?

    grid = grid.update do |rows|
      rows[destination.row][destination.col] = '@'
      rows[point.row][point.col] = '.'
      rows[target.row][target.col] = 'O'
    end
    return [grid, destination]
  end

  raise "Invalid point #{destination}"
end

def gps(grid, point)
  return 0 unless crate?(grid, point)

  (point.row * 100) + point.col
end

def find_robot(grid)
  grid.rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      return Point.new(r, c) if col == '@'
    end
  end
end

def part1(input)
  parts = input.split("\n\n")
  grid = Grid.new(parts[0].split("\n").map(&:chars))
  robot = find_robot(grid)

  directions = parts[1].split("\n").join.strip

  # grid.debug
  directions.chars.map { char_to_direction _1 }.each do |direction|
    # puts direction
    grid, robot = move(grid, robot, direction)
    # grid.debug rows
  end

  result = 0
  grid.rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      result += gps(grid, Point.new(r, c))
    end
  end

  puts result
end

def expand(grid)
  expanded = []
  grid.rows.each do |row|
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
  Grid.new(expanded)
end

def push_crate(grid, crate, direction)
  raise 'Not implemented'
end

def move2(grid, point, direction)
  destination = point.go(direction)
  return [grid, point] if wall?(grid, destination)

  if empty?(grid, destination)
    grid = grid.update do |rows|
      rows[destination.row][destination.col] = '@'
      rows[point.row][point.col] = '.'
    end
    return [grid, destination]
  end

  return push_crate(grid, destination, direction) if crate?(grid, destination)

  raise "Invalid point #{destination}"
end

def part2(input)
  parts = input.split("\n\n")
  grid = Grid.new(parts[0].split("\n").map(&:chars))
  grid = expand(grid)

  robot = find_robot(grid)

  directions = parts[1].split("\n").join.strip

  grid.debug
  directions.chars.map { char_to_direction _1 }.each do |direction|
    puts direction
    robot = move2(grid, robot, direction)
    grid.debug
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
