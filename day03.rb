#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 3

def part1(input)
  matches = input.scan(/mul\((\d+),(\d+)\)/)
  puts matches
    .map { |match| match.map(&:to_i) }
    .map { |numbers| numbers[0] * numbers[1] }
    .sum
end

def part2(input)
  matches = input.scan(/(do\(\))|(don't\(\))|mul\((\d+),(\d+)\)/)
  enabled = true
  products = []
  matches.each do |match|
    on, off, a, b = match
    unless on.nil?
      enabled = true
      next
    end
    unless off.nil?
      enabled = false
      next
    end
    products.push(a.to_i * b.to_i) if enabled
  end
  puts products.sum
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
