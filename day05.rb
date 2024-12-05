#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 5

## Represents a rule
class Rule
  def initialize(first, second)
    @first = first
    @second = second
  end

  attr_reader :first, :second

  def valid?(sequence)
    first_index = sequence.index(@first)
    second_index = sequence.index(@second)
    return true if first_index.nil? || second_index.nil?

    first_index < second_index
  end
end

def part1(input)
  parts = input.split("\n\n")
  rule_specs = parts[0].split("\n")
  sequence_specs = parts[1].split("\n")

  rules = rule_specs.map do |spec|
    values = spec.split('|').map(&:to_i)
    Rule.new(values[0], values[1])
  end
  puts "Parsed #{rules.length} rules"

  sequences = sequence_specs.map do |spec|
    spec.split(',').map(&:to_i)
  end
  puts "Parsed #{sequences.length} sequences"

  valid_sequences = sequences.filter do |sequence|
    rules.all? { |rule| rule.valid? sequence }
  end
  puts "Found #{valid_sequences.length} valid sequences"

  mid_points = valid_sequences.map do |sequence|
    sequence[sequence.length / 2]
  end

  puts mid_points.sum
end

## Return first broken rule
def validate(sequence, rules)
  rules.each do |rule|
    return rule unless rule.valid? sequence
  end
  nil
end

def swap(sequence, rule)
  first_index = sequence.index(rule.first)
  second_index = sequence.index(rule.second)

  tmp = sequence[first_index]
  sequence[first_index] = sequence[second_index]
  sequence[second_index] = tmp
end

def fix(sequence, rules)
  is_broken = true
  while is_broken
    broken_rule = validate(sequence, rules)
    break if broken_rule.nil?

    swap(sequence, broken_rule)
  end
  sequence
end

def part2(input)
  parts = input.split("\n\n")
  rule_specs = parts[0].split("\n")
  sequence_specs = parts[1].split("\n")

  rules = rule_specs.map do |spec|
    values = spec.split('|').map(&:to_i)
    Rule.new(values[0], values[1])
  end
  puts "Parsed #{rules.length} rules"

  sequences = sequence_specs.map do |spec|
    spec.split(',').map(&:to_i)
  end
  puts "Parsed #{sequences.length} sequences"

  invalid_sequences = sequences.filter do |sequence|
    rules.any? { |rule| !rule.valid? sequence }
  end
  puts "Found #{invalid_sequences.length} invalid sequences"

  fixed_sequences = invalid_sequences.map do |sequence|
    fix(sequence, rules)
  end

  mid_points = fixed_sequences.map do |sequence|
    sequence[sequence.length / 2]
  end

  puts mid_points.sum
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
