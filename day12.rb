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

  plot = flood(rows[0][0])
  puts plot.map(&:to_s)
  puts plot.length
  exit

  gardens = {}
  rows.each do |row|
    row.each do |col|
      gardens[col.value] = [] unless gardens.key? col.value
      gardens[col.value].push(col)
      # puts "#{col.value} => #{gardens[col.value].map(&:to_s)}"
    end
  end

  result = 0
  gardens.each do |char, plots|
    total_perimiter = plots.map(&:perimiter).map(&:length).sum
    area = plots.length
    price = total_perimiter * area
    # puts "#{char} => #{plots.map(&:to_s)}"
    puts "#{char} has area #{area} and perimiter #{total_perimiter} for price #{price}"
    result += price
  end

  puts "Found #{gardens.length} letters"

  # Expected: 1930 for example input
  puts result
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
