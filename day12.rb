#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 12

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

    return nil if neighbor_row < 0 || neighbor_row >= @rows.length
    return nil if neighbor_col < 0 || neighbor_col >= @rows.length

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

  def to_s
    "(#{@row}, #{@col})=#{@value}"
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
  value = point.value

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

def part1(input)
  rows = input.split("\n").map(&:chars)
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      rows[r][c] = Point.new(r, c, col, rows)
    end
  end

  plotted = Set.new
  plots = []
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      next if plotted.include?(col)

      plot = flood(col)
      plots.push(plot)
      plotted.merge(plot)
    end
  end

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

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
