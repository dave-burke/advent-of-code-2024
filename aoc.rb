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

  def self.download_input_if_needed(day)
    file_name = "day#{day.to_s.rjust(2, '0')}.txt"
    return if File.exist? file_name

    year = determine_year
    cookie = File.read('session.txt')
    headers = { Cookie: cookie }
    uri = "https://adventofcode.com/#{year}/day/#{day}/input"
    puts "GET #{uri} > #{file_name}"
    input = Net::HTTP.get(URI(uri), headers)
    File.write(file_name, input)
  end
end
