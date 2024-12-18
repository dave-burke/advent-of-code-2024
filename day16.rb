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

## A step in the race
class Step
  def initialize(point, type, direction)
    raise 'point must be a non-nil Point' if point.nil? || !point.is_a?(Point)
    raise 'type must not be nil' if point.nil?
    raise 'direction must be a non-nil Direction' if direction.nil? || !direction.is_a?(Direction)

    @point = point
    @type = type
    @direction = direction
  end

  attr_reader :point, :type, :direction

  def ==(other)
    eql? other
  end

  def eql?(other)
    self.class == other.class &&
      @point == other.point &&
      @type == other.type &&
      @direction == other.direction
  end

  def to_s
    case @type
    when :turn
      "Turn to #{@direction} at #{@point}"
    when :move
      "Move #{@direction} to #{@point}"
    when :start
      "Start at #{point}"
    else
      raise "Bad step: #{point} #{type} #{direction}"
    end
  end

  def inspect
    to_s
  end
end

def oposite?(direction_a, direction_b)
  return false if direction_a == direction_b
  return true if direction_a.offset_row == direction_b.offset_row

  true if direction_a.offset_col == direction_b.offset_col
end

## A full route
class Route
  def initialize(*start)
    raise "Invalid route steps: #{start}" unless start.all? { _1.is_a? Step }

    @path = start.freeze
  end

  def last
    @path.last
  end

  def calc_steps_to(point, direction)
    if @path.map(&:point).include? point
      LOG.debug("#{point} is already in this route.")
      return nil
    end
    current_direction = @path.last.direction
    return nil if oposite? direction, current_direction

    return [Step.new(point, :move, direction)] if direction == current_direction

    [Step.new(@path.last.point, :turn, direction), Step.new(point, :move, direction)]
  end

  def add_steps(steps)
    Route.new(*(@path + steps))
  end

  def length
    @path.length
  end

  def cost
    points = @path.map do |step|
      case step.type
      when :move
        1
      when :turn
        1000
      when :start
        0
      else
        raise "Invalid type #{step.type}"
      end
    end
    points.sum
  end

  def debug(grid)
    grid = grid.update do |rows|
      @path.each do |step|
        step_char = case step.direction.name
                    when 'UP'
                      '^'
                    when 'DOWN'
                      'v'
                    when 'LEFT'
                      '<'
                    when 'RIGHT'
                      '>'
                    end
        rows[step.point.row][step.point.col] = step_char
      end
    end
    grid.debug
  end

  def to_s
    @path.to_s
  end
end

def find_next_moves(grid, point)
  grid.neighbors4(point).reject { wall?(grid, _2) }
end

def part1(input)
  grid = Grid.from_string(input)
  start = grid.find_first('S')
  finish = grid.find_first('E')
  LOG.info("Finding route from #{start} to #{finish}")

  routes = [Route.new(Step.new(start, :start, DIRECTIONS[:RIGHT]))]

  full_routes = []
  # i = 0
  until routes.empty?
    route = routes.shift # shift = bfs, pop = dfs
    # route.debug(grid) # if (i % 10_000).zero?
    # gets
    # i += 1
    next_moves = find_next_moves(grid, route.last.point)
    LOG.debug("From #{route.last.point}, can move to any of  #{next_moves}")
    next_moves.each do |direction, point|
      new_steps = route.calc_steps_to(point, direction)
      next if new_steps.nil?

      LOG.debug("Can get to #{point} via #{new_steps}")

      new_route = route.add_steps(new_steps)
      if point == finish
        LOG.info("Success! #{new_route}")
        full_routes.push(new_route)
        break
      end
      LOG.debug("Route is now #{new_route.length} steps")
      routes.push(new_route)
    end
  end

  LOG.info("Found #{full_routes.length} routes to the end")
  min = full_routes.map(&:cost).min
  LOG.info("The cheapest route costs #{min}")
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
