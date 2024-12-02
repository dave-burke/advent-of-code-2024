# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

Aoc.download_input_if_needed(1)

lines = File.readlines('day01.txt')

pairs = lines.map do |line|
  /(\d+)   (\d+)/.match(line).to_a.drop(1).map(&:to_i)
end

left, right = pairs.transpose

left.sort!
right.sort!

sorted_pairs = [left, right].transpose

diffs = sorted_pairs.map { |l, r| (l - r).abs }

puts diffs.sort!.sum
