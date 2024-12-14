#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'

DAY = 14

LOG = Logger.new($stdout)
LOG.level = Logger::DEBUG
LOG.formatter = proc do |severity, datetime, _, msg|
  "#{datetime.strftime('%H:%M:%S')} #{severity.ljust(5)}: #{msg}\n"
end

## Robot guard
class Robot
  def initialize(pos, velocity, max)
    @pos_x, @pos_y = pos
    @velocity_x, @velocity_y = velocity
    @max_x, @max_y = max
  end

  def self.from_spec(spec, max_x, max_y)
    _, pos_x, pos_y, velocity_x, velocity_y =
      /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/.match(spec).to_a
    LOG.debug([pos_x.to_i, pos_y.to_i, velocity_x.to_i, velocity_y.to_i])
    Robot.new([pos_x.to_i, pos_y.to_i], [velocity_x.to_i, velocity_y.to_i], [max_x, max_y])
  end

  attr_reader :pos_x, :pos_y, :velocity_x, :velocity_y

  def move(steps)
    new_pos_x = (@pos_x + (@velocity_x * steps)) % @max_x
    new_pos_y = (@pos_y + (@velocity_y * steps)) % @max_y
    Robot.new([new_pos_x, new_pos_y], [@velocity_x, @velocity_y], [@max_x, @max_y])
  end

  def to_s
    "#{pos_y}, #{pos_x}"
  end
end

def debug(robots, max_x, max_y)
  (0..max_y - 1).each do |y|
    (0..max_x - 1).each do |x|
      count = robots.count { _1.pos_x == x && _1.pos_y == y }
      if count > 0
        print count
      else
        print '.'
      end
    end
    print "\n"
  end
end

def count_quadrants(robots, max_x, max_y)
  mid_x = max_x / 2
  mid_y = max_y / 2

  top_left = 0
  top_right = 0
  bottom_left = 0
  bottom_right = 0

  robots.each do |robot|
    next if robot.pos_x == mid_x || robot.pos_y == mid_y

    top = robot.pos_y < mid_y
    left = robot.pos_x < mid_x

    top_left += 1 if top && left
    top_right += 1 if top && !left
    bottom_left += 1 if !top && left
    bottom_right += 1 if !top && !left
  end
  [top_left, top_right, bottom_left, bottom_right]
end

def do_part1(input, steps, max_x, max_y)
  robots = input.split("\n").map { Robot.from_spec(_1, max_x, max_y) }
  moved = robots.map { _1.move(steps) }
  # debug(moved, max_x, max_y)
  counts = count_quadrants(moved, max_x, max_y)
  LOG.info(counts)
  counts.reduce(1, :*)
end

def part1(input)
  # result = do_part1(input, 100, 11, 7)
  result = do_part1(input, 100, 101, 103)

  LOG.info(result)
end

def count_neighbors(robots)
  count = 0
  robots.each do |robot|
    count += 1 if robots.any? { _1.pos_x == robot.pos_x - 1 && _1.pos_y == robot.pos_y }
    count += 1 if robots.any? { _1.pos_x == robot.pos_x + 1 && _1.pos_y == robot.pos_y }
    count += 1 if robots.any? { _1.pos_x == robot.pos_x && _1.pos_y == robot.pos_y - 1 }
    count += 1 if robots.any? { _1.pos_x == robot.pos_x && _1.pos_y == robot.pos_y + 1 }
  end
  count
end

def part2(input)
  max_x = 101
  max_y = 103
  robots = input.split("\n").map { Robot.from_spec(_1, max_x, max_y) }

  max_count = 0
  max_count_step = 0
  (5000..10_000).each do |steps|
    moved = robots.map { _1.move(steps) }
    count = count_neighbors(moved)
    if count > max_count
      LOG.info("New max: #{count}")
      max_count = count
      max_count_step = steps
      debug(moved, max_x, max_y)
    else
      LOG.info("#{steps} steps")
    end
  end
  LOG.info("Check #{max_count_step}")
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
