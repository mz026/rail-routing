require_relative './line_stop'

class Station
  attr_reader :name

  class << self
    def create line_code, line_num, name, start_date
      @station_pool ||= {}

      line_stop = LineStop.new(line_code, line_num, start_date)
      station = get_station(name)
      station.add_line_stop(line_stop)
      station
    end

    def connect station_a, station_b
      station_a.add_neighbor(station_b)
      station_b.add_neighbor(station_a)
    end

    def get_station name
      @station_pool ||= {}

      if !@station_pool[name]
        @station_pool[name] = self.new(name)
      end
      @station_pool[name]
    end
    private :get_station
  end

  def initialize name
    @name = name
    @neighbor_stations = []
    @line_stops = []
  end
  private :initialize

  def add_neighbor station
    if ! @neighbor_stations.find {|s| s.name == station.name}
      @neighbor_stations << station
    end
  end

  def add_line_stop stop
    @line_stops << stop
  end

  def get_neighbors
    @neighbor_stations
  end
end
