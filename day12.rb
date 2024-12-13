#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

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

DIRECTIONS_4 = [
  Direction.new('LEFT', 0, -1),
  Direction.new('UP', -1, 0),
  Direction.new('RIGHT', 0, 1),
  Direction.new('DOWN', 1, 0)
].freeze

DIRECTIONS_8 = [
  Direction.new('LEFT', 0, -1),
  Direction.new('LEFT_UP', -1, -1),
  Direction.new('UP', -1, 0),
  Direction.new('UP_RIGHT', -1, 1),
  Direction.new('RIGHT', 0, 1),
  Direction.new('DOWN_RIGHT', 1, 1),
  Direction.new('DOWN', 1, 0),
  Direction.new('DOWN_LEFT', 1, -1)
].freeze

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

  def perimiter_with_diagonals
    DIRECTIONS_8.map { |d| go(d) }
                .filter { |n| n.value.nil? || n.value != @value }
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
    # puts "#{char} => #{plots.map(&:to_s)}"
    puts "#{plot.first.value} has area #{area} and perimiter #{total_perimiter} for price #{price}"
    result += price
  end

  puts "Found #{plots.length} gardens"

  # Expected: 1930 for example input
  puts result
end

def follow_wall(point, direction, perimiter)
  points = []
  while perimiter.include?(point)
    points.push(point)
    point = point.go(direction)
  end
  points
end

def change_direction(point, visited, perimiter)
  DIRECTIONS_4.each do |direction|
    next_point = point.go(direction)
    return direction if perimiter.include?(next_point) && !visited.include?(next_point)
  end
  nil
end

def count_walls(perimiter)
  walls = 0

  point = perimiter.first
  visited = [point]
  direction = change_direction(point, visited, perimiter)
  until direction.nil?
    walls += 1
    wall = follow_wall(point, direction, perimiter)
    puts "Following #{wall.map(&:to_s)}"
    point = wall.last
    visited += wall
    direction = change_direction(point, visited, perimiter)
    puts "Turning #{direction.name} at #{point}" unless direction.nil?
  end

  walls
end

def part2(input)
  rows = read_rows(input)

  plots = find_plots(rows)
          .filter { |p| p.to_a[0].value == 'C' }

  plot = plots[0]
  puts "Plot: #{plot.map(&:to_s)}"
  perimiter = Set.new(plot.map(&:perimiter_with_diagonals).flatten)
  puts "Perimiter: #{perimiter.map(&:to_s)}"

  walls = count_walls(perimiter)

  puts "Found #{walls} walls"

  rows.each do |row|
    row.each do |point|
      if plot.include? point
        print '.'
      elsif perimiter.include? point
        print '+'
      else
        print point.value
      end
    end
    print "\n"
  end

  exit

  result = 0
  plots.each do |plot|
    puts "Plot: #{plot.map(&:to_s)}"
    walls = count_walls(plot)
    area = plot.length

    price = walls * area
    puts "#{plot.first.value} has area #{area} and #{walls} walls for price #{price}"
    result += price
  end

  puts result
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
