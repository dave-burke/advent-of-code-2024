require 'date'

module Aoc
  def self.download_input_if_needed(day)
    file_name = "day#{day.to_s().rjust(2, '0')}.txt"
    if !File.exist? file_name
      today = Date.today
      if today.month == 12
        year = today.year
      else
        year = today.year - 1
      end
      cookie = File.read('session.txt')
      headers = {Cookie: cookie }
      uri = "https://adventofcode.com/#{year}/day/#{day}/input"
      puts "GET #{uri} > #{file_name}"
      input = Net::HTTP.get(URI(uri), headers)
      File.write(file_name, input)
      puts input
    end
  end
end
