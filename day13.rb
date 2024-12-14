#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'logger'
require_relative 'aoc'

DAY = 13

LOG = Logger.new($stdout)
LOG.level = Logger::INFO
LOG.datetime_format = '%Y-%m-%d %H:%M'
LOG.formatter = proc do |severity, datetime, _, msg|
  date_format = datetime.strftime('%H:%M:%S')
  "#{date_format} #{severity.ljust(5)}: #{msg}\n"
end

## Button A: X+[delta_x], Y+[delta_y]
class Button
  def initialize(spec)
    _, @name, @delta_x, @delta_y = /Button (.): X\+(\d+), Y\+(\d+)/.match(spec).to_a
    @delta_x = @delta_x.to_i
    @delta_y = @delta_y.to_i
  end

  attr_reader :name, :delta_x, :delta_y

  def to_s
    "Button #{@name}: X+#{@delta_x}, Y+#{@delta_y}"
  end
end

## Prize: X=[x_pos], Y=[y_pos]
class Prize
  def initialize(spec)
    _, @x_pos, @y_pos = /Prize: X=(\d+), Y=(\d+)/.match(spec).to_a
    @x_pos = @x_pos.to_i
    @y_pos = @y_pos.to_i
  end

  attr_reader :x_pos, :y_pos

  def to_s
    "Prize: X=#{@x_pos}, Y=#{@y_pos}"
  end
end

## A machine from a 3-line spec
class Machine
  def initialize(spec)
    a_spec, b_spec, prize_spec = spec.split("\n")
    @button_a = Button.new(a_spec)
    @button_b = Button.new(b_spec)
    @prize = Prize.new(prize_spec)
  end

  attr_reader :button_a, :button_b, :prize

  def to_s
    "#{@button_a}\n#{@button_b}\n#{@prize}"
  end
end

def solve_x(machine)
  max_a = machine.prize.x_pos / machine.button_a.delta_x

  LOG.debug("Max A presses = #{max_a}")

  results = []
  (0..max_a).each do |test_a|
    x_value = machine.button_a.delta_x * test_a
    remainder = machine.prize.x_pos - x_value

    LOG.debug("If you press A #{test_a} times, you'll have #{remainder} of X leftover")
    next unless (remainder % machine.button_b.delta_x).zero?

    test_b = remainder / machine.button_b.delta_x

    x_value_b = machine.button_b.delta_x * test_b
    LOG.debug("#{test_a} * #{machine.button_a.delta_x} = #{test_a * machine.button_a.delta_x} (#{x_value})")
    LOG.debug("#{test_b} * #{machine.button_b.delta_x} = #{test_b * machine.button_b.delta_x} (#{x_value_b})")
    LOG.debug(x_value + x_value_b)
    results.push([test_a, test_b])
  end
  results
end

def test_y(machine, solution)
  (solution[0] * machine.button_a.delta_y) + (solution[1] * machine.button_b.delta_y) == machine.prize.y_pos
end

def calc_cost(solution)
  (solution[0] * 3) + solution[1]
end

def find_cheapest(solutions)
  result = []
  solutions.each do |solution|
    cost = calc_cost(solution)
    result = [solution, cost] if result.empty? || cost < result[1]
  end
  result
end

def part1(input)
  specs = input.split("\n\n")

  machines = specs.map { Machine.new(_1) }

  result = 0
  machines.each do |machine|
    LOG.info("\n#{machine}")
    solutions = solve_x(machine)
    LOG.debug("Found #{solutions.length} possible solutions")
    solutions = solutions.filter { test_y(machine, _1) }
    LOG.debug("#{solutions.length} of those work with Y")
    solution, cost = find_cheapest(solutions)
    LOG.info("Cheapest: #{solution} = #{cost}")
    result += cost unless cost.nil?
  end
  LOG.info("Fewest tokens = #{result}")
end

def part2(input)
  # Add 10_000_000_000_000
  puts 'not implemented'
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
