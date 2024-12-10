#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 10

## Represents a point on the grid
class Point
  def initialize(row, col, rows)
    @row = row
    @col = col
    @rows = rows
  end

  attr_reader :row, :col, :rows

  def value
    rows[@row][@col].to_i
  end

  def to_s
    "(#{@row}, #{@col}) = #{value}"
  end

  def in_bounds?
    @row >= 0 && @row < @rows.length &&
      @col >= 0 && @col < @rows[0].length
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

  def paths
    possible_paths = [
      Point.new(@row - 1, @col, rows), # up
      Point.new(@row, @col + 1, rows), # right
      Point.new(@row + 1, @col, rows), # down
      Point.new(@row, @col - 1, rows)  # right
    ]
    # remove out of bounds and invalid paths
    possible_paths.filter do |path|
      path.in_bounds? && path.value == value + 1
    end
  end
end

def find_trailheads(rows)
  trailheads = []
  rows.each_with_index do |row, r|
    row.each_with_index do |_, c|
      point = Point.new(r, c, rows)
      trailheads.push(point) if point.value.zero?
    end
  end
  trailheads
end

def score_trailhead(trailhead)
  trails = [trailhead]
  puts "Scoring #{trailhead}"

  summits = Set.new
  until trails.empty?
    trail = trails.pop
    if trail.value == 9
      puts "#{trail} is the end of a full trail"
      summits.add(trail)
      next
    end
    possible_paths = trail.paths
    # puts "Continuing #{trail} => #{possible_paths.map(&:to_s)}"
    trails.push(*possible_paths)
  end
  summits.length
end

def part1(input)
  rows = input.split("\n").map(&:chars)
  puts rows.map(&:join)

  trailheads = find_trailheads(rows)
  puts "Trailheads: #{trailheads.map(&:to_s)}"

  result = 0

  trailheads.each do |trailhead|
    result += score_trailhead(trailhead)
  end

  puts "Total score: #{result}"
end

def part2(input)
  rows = input.split("\n").map(&:chars)
  puts rows.map(&:join)

  trails = find_trailheads(rows)
  puts "Trailheads: #{trails.map(&:to_s)}"

  score = 0
  until trails.empty?
    trail = trails.pop
    if trail.value == 9
      puts "#{trail} is the end of a full trail"
      score += 1
      next
    end
    possible_paths = trail.paths
    # puts "Continuing #{trail} => #{possible_paths.map(&:to_s)}"
    trails.push(*possible_paths)
  end

  puts "Total score: #{score}"
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
