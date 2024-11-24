require 'net/http'
require_relative 'aoc'

Aoc::download_input_if_needed(1)
File.readlines('day01.txt').each_with_index do | line, i |
  puts line
end

