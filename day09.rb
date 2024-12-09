#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 9

## Represents a contiguous block for data for a single file
class Block
  def initialize(id, length)
    @id = id
    @length = length
  end

  attr_reader :id, :length

  def to_s
    "{#{@id}x#{@length}}"
  end
end

def part1(input)
  is_file = true
  next_id = 0
  blocks = []
  input.strip.chars.each do |char|
    if is_file
      blocks << Block.new(next_id, char)
      next_id += 1
    else
      blocks << Block.new(nil, char)
    end
    is_file = !is_file
  end

  puts "#{blocks.map(&:to_s)}"
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
