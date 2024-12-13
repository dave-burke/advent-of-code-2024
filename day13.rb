#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 13

## Button A: X+[delta_x], Y+[delta_y]
class Button
  def initialize(spec)
    _, @name, @delta_x, @delta_y = /Button (.): X\+(\d+), Y\+(\d+)/.match(spec).to_a
  end

  def to_s
    "Button #{@name}: X+#{@delta_x}, Y+#{@delta_y}"
  end
end

## Prize: X=[x_pos], Y=[y_pos]
class Prize
  def initialize(spec)
    _, @x_pos, @y_pos = /Prize: X=(\d+), Y=(\d+)/.match(spec).to_a
  end

  def to_s
    "Prize: X=#{@x_pos}, Y=#{@y_pos}"
  end
end

class Machine
  def initialize(spec)
    a_spec, b_spec, prize_spec = spec.split("\n")
    @button_a = Button.new(a_spec)
    @button_b = Button.new(b_spec)
    @prize_spec = Prize.new(prize_spec)
  end

  def to_s
    "#{@button_a}\n#{@button_b}\n#{@prize_spec}\n"
  end
end

def part1(input)
  specs = input.split("\n\n")

  machines = specs.map { Machine.new(_1) }

  machines.each do |machine|
    puts machine
    puts ''
  end
end

def part2(input)
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
