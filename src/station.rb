class Station
  attr_reader :name, :line_code, :line_number, :neighbors

  class Map
    def initialize
      @station_pool = {}
    end

    def add line_code, line_number, name, start_date = nil
      @station_pool ||= {}

      station = Station.new(name, line_code, line_number)
      if @station_pool[name]
        @station_pool[name].each do |st|
          Station.connect(st, station) if st.line_code != station.line_code
        end
      end
      add_to_pool(station)
      station
    end

    def add_to_pool station
      @station_pool[station.name] ||= []
      @station_pool[station.name] << station
    end
    private :add_to_pool

    def find_stations name
      @station_pool[name] || []
    end
  end

  def self.connect station_a, station_b
    station_a.add_neigber(station_b)
    station_b.add_neigber(station_a)
  end

  def initialize name, line_code, line_number
    @name = name
    @neighbors = []
    @line_code = line_code
    @line_number = line_number
  end

  def connections
    @neighbors
  end

  def == another
    line_code == another.line_code && line_number == another.line_number
  end

  def add_neigber station
    existing_neighbor = @neighbors.find do |s|
      s == station
    end
    @neighbors << station unless existing_neighbor
  end

  def station_code
    "#{@line_code}#{@line_number}"
  end
end
