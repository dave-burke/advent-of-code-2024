# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

def part1(input)
  pairs = input.split(/\n/).map do |line|
    /(\d+)   (\d+)/.match(line).to_a.drop(1).map(&:to_i)
  end

  left, right = pairs.transpose

  left.sort!
  right.sort!

  sorted_pairs = [left, right].transpose

  diffs = sorted_pairs.map { |l, r| (l - r).abs }

  puts diffs.sort!.sum
end

def part2(input)
  pairs = input.split(/\n/).map do |line|
    /(\d+)   (\d+)/.match(line).to_a.drop(1).map(&:to_i)
  end

  left, right = pairs.transpose

  counts = {}
  right.each do |n|
    if counts.key? n
      counts[n] += 1
    else
      counts[n] = 1
    end
  end

  similarity_score = 0
  left.each do |n|
    similarity_score += n * counts[n] if counts.key? n
  end

  puts similarity_score
end

input = Aoc.download_input_if_needed(1)
part2(input)
# 20707984 is too low
