require 'time'
require_relative './station'

class MapBuilder
  def initialize
    @last_line_station = {}
  end

  def build arr, current_time: nil, excluded_lines: []
    map = Station::Map.new

    arr.each do |code, name, date|
      next if excluded?(code, date, current_time, excluded_lines)

      line_code, line_number = parse_code(code)
      station = map.add(line_code, line_number, name, date)
      last_station = get_last_build_station(line_code)
      Station.connect(station, last_station) if last_station
      register_build_station(line_code, station)
    end

    map
  end

  def excluded? line_code, date, current_time, excluded_lines
    excluded_lines.include?(line_code) ||
      (current_time && current_time < Time.parse(date))
  end
  private :excluded?

  def register_build_station line_code, st
    @last_line_station[line_code] = st
  end
  private :register_build_station

  def get_last_build_station line_code
    @last_line_station[line_code]
  end
  private :get_last_build_station

  def parse_code code
    line_code = code.match(/[a-zA-Z]+/)[0]
    line_number = code.match(/\d+/)[0]
    [line_code, line_number]
  end
  private :parse_code
end
