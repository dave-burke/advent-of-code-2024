#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 8

def map_points(rows)
  char_points = {}
  rows.each_with_index do |row, r|
    row.each_with_index do |col, c|
      next if col == '.'

      char_points[col] = [] unless char_points.key?(col)
      char_points[col].push([r, c])
    end
  end
  char_points
end

def calc_dist(point_a, point_b)
  [point_b[0] - point_a[0], point_b[1] - point_a[1]]
end

def project(point, delta)
  [point[0] + delta[0], point[1] + delta[1]]
end

def in_bounds?(point, rows)
  point[0] >= 0 && point[0] < rows.length && point[1] >= 0 && point[1] < rows[0].length
end

def part1(input)
  rows = input.split("\n").map { |line| line.split('') }

  char_points = map_points(rows)

  unique_points = Set.new
  char_points.each do |char, points|
    puts "Combinations of #{char}:"
    points.permutation(2).each do |pair|
      dist = calc_dist(pair[0], pair[1])
      projected = project(pair[1], dist)
      next unless in_bounds?(projected, rows)

      puts "#{pair} => #{dist} => #{projected}"
      unique_points.add projected
      rows[projected[0]][projected[1]] = '#'
    end
  end
  rows.each do |row|
    puts row.join
  end

  puts unique_points.length
end

def part2(input)
  rows = input.split("\n").map { |line| line.split('') }

  char_points = map_points(rows)

  unique_points = Set.new
  char_points.each do |char, points|
    puts "Combinations of #{char}:"
    unique_points.merge(points)
    points.permutation(2).each do |pair|
      dist = calc_dist(pair[0], pair[1])
      projected = project(pair[1], dist)
      while in_bounds?(projected, rows)
        puts "#{pair} => #{dist} => #{projected}"
        unique_points.add projected
        rows[projected[0]][projected[1]] = '#'

        projected = project(projected, dist)
      end
    end
  end
  rows.each do |row|
    puts row.join
  end

  puts unique_points.length
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
