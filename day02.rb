# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

input = Aoc.download_input_if_needed(2)

lines = input.split('\n')

lines.each do |line|
  puts line
end
