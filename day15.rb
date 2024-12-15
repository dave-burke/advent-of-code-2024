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
end

def direction(char)
  case char
  when '<'
    DIRECTIONS.LEFT
  when '^'
    DIRECTIONS.UP
  when '>'
    DIRECTIONS.RIGHT
  when 'V'
    DIRECTIONS.DOWN
  end
end

def part1(input)
  parts = input.split("\n\n")
  rows = map_points(parts[0].split("\n").map(&:chars)) do |row, col, rows_arg|
    Point.new(row, col, rows_arg)
  end

  directions = parts[1].split("\n").join

  rows.each do |row|
    row.each do |col|
      print col.value
    end
    print "\n"
  end

  puts directions
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
