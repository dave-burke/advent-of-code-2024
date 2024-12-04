# frozen_string_literal: true

require 'date'

##
# Common Advent of Code utility methods
module Aoc
  def self.determine_year
    today = Date.today
    if today.month == 12
      today.year
    else
      today.year - 1
    end
  end

  def self.download_input(year, day, cookie)
    headers = { Cookie: cookie }
    uri = "https://adventofcode.com/#{year}/day/#{day}/input"
    puts "GET #{uri}"
    Net::HTTP.get(URI(uri), headers)
  end

  def self.download_input_if_needed(day)
    raise 'Day must be a positive integer' unless day.positive?

    file_name = "input#{day.to_s.rjust(2, '0')}.txt"
    return File.read(file_name) if File.exist? file_name

    year = determine_year
    cookie = File.read('session.txt')
    input = download_input(year, day, cookie)
    File.write(file_name, input)
    puts "Input saved as #{file_name}"

    input
  end
end
