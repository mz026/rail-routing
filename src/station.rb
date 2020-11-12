require_relative './line_stop'

class Station
  attr_reader :name, :line_stops

  class Map
    def add line_code, line_num, name, start_date
      @station_pool ||= {}

      line_stop = LineStop.new(line_code, line_num, start_date)
      station = find_or_create_station(name)
      station.add_line_stop(line_stop)
      station
    end

    def find_or_create_station name
      @station_pool ||= {}

      if !@station_pool[name]
        @station_pool[name] = Station.new(name)
      end
      @station_pool[name]
    end
    private :find_or_create_station

    def find_station name
      @station_pool[name]
    end
  end

  def self.connect station_a, station_b
    station_a.add_neighbor(station_b)
    station_b.add_neighbor(station_a)
  end

  def initialize name
    @name = name
    @neighbor_stations = []
    @line_stops = []
  end

  def add_neighbor station
    if ! @neighbor_stations.find {|s| s.name == station.name}
      @neighbor_stations << station
    end
  end

  def add_line_stop stop
    exists = @line_stops.find do |s|
      s.line_code == stop.line_code && s.line_number == stop.line_number
    end
    @line_stops << stop unless exists
  end

  def neighbors
    @neighbor_stations
  end
end
