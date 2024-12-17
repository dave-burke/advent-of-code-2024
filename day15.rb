#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'
require_relative 'point'

DAY = 15

LOG = Logger.new($stdout)
LOG.level = Logger::INFO
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

def part1(input)
  parts = input.split("\n\n")
  grid = Grid.new(parts[0].split("\n").map(&:chars))
  robot = grid.find_first('@')

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

def move_crate(grid, crate, direction)
  destination0 = crate[0].go(direction)
  destination1 = crate[1].go(direction)
  LOG.debug("Moving #{crate.map(&:to_s)} #{direction.name} to #{[destination0, destination1].map(&:to_s)}")
  grid.update do |rows|
    point_value!(rows, crate[0], '.')
    point_value!(rows, crate[1], '.')
    point_value!(rows, destination0, grid.value(crate[0]))
    point_value!(rows, destination1, grid.value(crate[1]))
  end
end

def destination_points(crate, direction)
  crate
    .map { _1.go(direction) }
    .reject { crate.include? _1 }
end

def complete_crate(grid, crate_point)
  if grid.value(crate_point) == '['
    [crate_point, crate_point.go(DIRECTIONS[:RIGHT])]
  else
    [crate_point.go(DIRECTIONS[:LEFT]), crate_point]
  end
end

def push_crate(grid, crate_part, direction)
  crate = complete_crate(grid, crate_part)
  destinations = destination_points(crate, direction)
  LOG.debug("Attempting to move #{crate.map(&:to_s)} to #{destinations.map(&:to_s)}")

  if destinations.any? { wall?(grid, _1) }
    LOG.debug('There is a wall in the way.')
    return nil
  end
  if destinations.all? { empty?(grid, _1) }
    LOG.debug('Success!')
    return move_crate(grid, crate, direction)
  end

  next_crates = destinations
                .filter { crate?(grid, _1) }
                .map { complete_crate(grid, _1) }
                .uniq

  result = grid
  unless next_crates.empty?
    LOG.debug("Need to move crates at #{next_crates.map { _1.map(&:to_s) }}")
    result = push_crate(result, next_crates[0][0], direction)
    return nil if result.nil?
  end
  if next_crates.length > 1
    result = push_crate(result, next_crates[1][0], direction)
    return nil if result.nil?
  end
  # successfully moved other crates
  move_crate(result, crate, direction)
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

  attempted_push = push_crate(grid, destination, direction) if crate?(grid, destination)
  return [grid, point] if attempted_push.nil?

  updated = attempted_push.update do |rows|
    rows[destination.row][destination.col] = '@'
    rows[point.row][point.col] = '.'
  end
  return [updated, destination]

  raise "Invalid point #{destination}"
end

def gps2(grid, point)
  return 0 unless grid.value(point) == '['

  (100 * point.row) + point.col
end

def part2(input)
  parts = input.split("\n\n")
  grid = Grid.new(parts[0].split("\n").map(&:chars))
  grid = expand(grid)

  robot = grid.find_first('@')

  directions = parts[1].split("\n").join.strip

  # grid.debug
  directions.chars.map { char_to_direction _1 }.each do |direction|
    # puts direction
    grid, robot = move2(grid, robot, direction)
    # grid.debug
    # sleep(0.2)
    # gets
  end

  result = 0
  grid.rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      result += gps2(grid, Point.new(r, c))
    end
  end

  puts result
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
