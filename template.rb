#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'

DAY = 0

LOG = Logger.new($stdout)
LOG.level = Logger::INFO
LOG.datetime_format = '%Y-%m-%d %H:%M'
LOG.formatter = proc do |severity, datetime, _, msg|
  date_format = datetime.strftime('%H:%M:%S')
  "#{date_format} #{severity.ljust(5)}: #{msg}\n"
end

def part1(input)
  lines = input.split("\n")
  LOG.info("There were #{lines.size} lines")
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
