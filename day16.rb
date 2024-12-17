#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'
require_relative 'point'

DAY = 16

LOG = Logger.new($stdout, level: Logger::DEBUG)
LOG.formatter = proc do |severity, datetime, _, msg|
  "#{datetime.strftime('%H:%M:%S')} #{severity.ljust(5)}: #{msg}\n"
end

def wall?(grid, point)
  grid.value(point) == '#'
end

def find_next_moves(grid, point)
  grid.neighbors4(point).reject { wall?(grid, _2) }
end

def part1(input)
  grid = Grid.from_string(input)
  start = grid.find_first('S')
  finish = grid.find_first('E')
  LOG.info("Finding route from #{start} to #{finish}")

  next_moves = find_next_moves(grid, start)

  LOG.info("First move could be to any of #{next_moves}")
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
