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

  Connection = Struct.new(:station, :line_code)

  def self.connect station_a, station_b, line_code
    station_a.add_connection(station_b, line_code)
    station_b.add_connection(station_a, line_code)
  end

  def initialize name
    @name = name
    @connections = []
    @line_stops = []
  end

  def add_connection station, line_code
    existing_conn = @connections.find do |c|
      c.line_code == line_code && c.station.name == station.name
    end
    @connections << Connection.new(station, line_code) unless existing_conn
  end

  def add_line_stop stop
    exists = @line_stops.find do |s|
      s.line_code == stop.line_code && s.line_number == stop.line_number
    end
    @line_stops << stop unless exists
  end

  def connections
    @connections
  end
end
