#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'logger'
require_relative 'aoc'

LOG = Logger.new($stdout)
LOG.level = Logger::INFO
LOG.datetime_format = '%Y-%m-%d %H:%M'
LOG.formatter = proc do |severity, datetime, _, msg|
  date_format = datetime.strftime('%H:%M:%S')
  "#{date_format} #{severity.ljust(5)}: #{msg}\n"
end

DAY = 12

## Represents a direction to move
class Direction
  def initialize(name, offset_row, offset_col)
    @name = name
    @offset_row = offset_row
    @offset_col = offset_col
  end

  attr_reader :name, :offset_row, :offset_col
end

LEFT = Direction.new('LEFT', 0, -1)
UP_LEFT = Direction.new('LEFT_UP', -1, -1)
UP = Direction.new('UP', -1, 0)
UP_RIGHT = Direction.new('UP_RIGHT', -1, 1)
RIGHT = Direction.new('RIGHT', 0, 1)
DOWN_RIGHT = Direction.new('DOWN_RIGHT', 1, 1)
DOWN = Direction.new('DOWN', 1, 0)
DOWN_LEFT = Direction.new('DOWN_LEFT', 1, -1)

class Point
  def initialize(row, col, value, rows)
    @row = row
    @col = col
    @value = value
    @rows = rows
  end

  attr_reader :row, :col, :value

  def neighbor(delta_row, delta_col)
    neighbor_row = @row + delta_row
    neighbor_col = @col + delta_col

    if neighbor_row.negative? || neighbor_row >= @rows.length ||
       neighbor_col.negative? || neighbor_col >= @rows.length
      return Point.new(neighbor_row, neighbor_col, nil, @rows)
    end

    @rows[neighbor_row][neighbor_col]
  end

  def interior
    [
      neighbor(-1, 0), # UP
      neighbor(0, 1), # RIGHT
      neighbor(1, 0), # DOWN
      neighbor(0, -1) # LEFT
    ].filter { |n| !n.nil? && n.value == @value }
  end

  def perimiter
    [
      neighbor(-1, 0), # UP
      neighbor(0, 1), # RIGHT
      neighbor(1, 0), # DOWN
      neighbor(0, -1) # LEFT
    ].filter { |n| n.nil? || n.value != @value }
  end

  def go(direction)
    new_row = @row + direction.offset_row
    new_col = @col + direction.offset_col
    new_value = if new_row.negative? || new_row >= @rows.length ||
                   new_col.negative? || new_col >= @rows.length
                  nil
                else
                  @rows[new_row][new_col].value
                end
    Point.new(new_row, new_col, new_value, @rows)
  end

  def to_s
    value = if @value.nil?
              'nil'
            else
              @value
            end
    "(#{@row}, #{@col})=#{value}"
  end

  def ==(other)
    eql? other
  end

  def eql?(other)
    self.class == other.class &&
      @row == other.row &&
      @col == other.col
  end

  def hash
    [self.class, @row, @col].hash
  end
end

def flood(point)
  todo = [point]
  plot = Set.new

  until todo.empty?
    point = todo.pop
    neighbors = point.interior
    neighbors.each do |neighbor|
      todo.push(neighbor) if !todo.include?(neighbor) && !plot.include?(neighbor)
    end
    plot.add(point)
  end
  plot
end

def read_rows(input)
  rows = input.split("\n").map(&:chars)
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      rows[r][c] = Point.new(r, c, col, rows)
    end
  end
end

def find_plots(rows)
  plotted = Set.new
  plots = []
  rows.each do |row|
    row.each do |col|
      next if plotted.include?(col)

      plot = flood(col)
      plots.push(plot)
      plotted.merge(plot)
    end
  end
  plots
end

def part1(input)
  rows = read_rows(input)

  plots = find_plots(rows)

  result = 0
  plots.each do |plot|
    total_perimiter = plot.map(&:perimiter).map(&:length).sum
    area = plot.length
    price = total_perimiter * area
    LOG.debug("#{char} => #{plots.map(&:to_s)}")
    LOG.info("#{plot.first.value} has area #{area} and perimiter #{total_perimiter} for price #{price}")
    result += price
  end

  LOG.info("Found #{plots.length} gardens")

  # Expected: 1930 for example input
  puts result
end

def convex_corner?(point, neighbors, plot)
  plot.include?(point) && neighbors.all? { !plot.include?(_1) }
end

def concave_corner?(gardens, neighbor, plot)
  gardens.all? { plot.include?(_1) } && !plot.include?(neighbor)
end

def count_corners(plot)
  result = 0
  plot.each do |point|
    # When A is in the plot
    up = point.go(UP)
    up_right = point.go(UP_RIGHT)
    right = point.go(RIGHT)
    down_right = point.go(DOWN_RIGHT)
    down = point.go(DOWN)
    down_left = point.go(DOWN_LEFT)
    left = point.go(LEFT)
    up_left = point.go(UP_LEFT)

    # AB
    # B
    if convex_corner?(point, [right, down], plot)
      LOG.debug("Found convex ◰ at #{point}")
      result += 1
    end

    # BA
    #  B
    if convex_corner?(point, [left, down], plot)
      LOG.debug("Found convex ◳ at #{point}")
      result += 1
    end

    #  B
    # BA
    if convex_corner?(point, [left, up], plot)
      LOG.debug("Found convex ◲ at #{point}")
      result += 1
    end

    # B
    # AB
    if convex_corner?(point, [right, up], plot)
      LOG.debug("Found convex ◱ at #{point}")
      result += 1
    end

    # BA
    # AA
    if concave_corner?([point, left, up], up_left, plot)
      LOG.debug("Found concave ◰ at #{point}")
      result += 1
    end

    # AB
    # AA
    if concave_corner?([point, right, up], up_right, plot)
      LOG.debug("Found concave ◳ at #{point}")
      result += 1
    end

    # AA
    # AB
    if concave_corner?([point, down, right], down_right, plot)
      LOG.debug("Found concave ◲ at #{point}")
      result += 1
    end

    # AA
    # BA
    if concave_corner?([point, left, down], down_left, plot)
      LOG.debug("Found convex ◱ at #{point}")
      result += 1
    end
  end
  result
end

def part2(input)
  rows = read_rows(input)

  plots = find_plots(rows)

  result = 0
  plots.each do |plot|
    LOG.debug("Plot: #{plot.map(&:to_s)}")
    # Number of corners = number of walls for any polygon
    walls = count_corners(plot)
    area = plot.length

    price = walls * area
    LOG.info("#{plot.first.value} has area #{area} and #{walls} walls for price #{price}")
    result += price
  end

  puts result
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
