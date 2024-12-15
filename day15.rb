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

def part1(input)
  parts = input.split("\n\n")
  rows = parts[0].split("\n").map(&:chars)

  directions = parts[1].split("\n").join.strip

  robot = nil
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      robot = Point.new(r, c, rows) if col == '@'
    end
    print "\n"
  end

  debug rows
  directions.chars.map { direction _1 }.each do |direction|
    puts direction
    robot = move(robot, direction)
    debug rows
  end
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
