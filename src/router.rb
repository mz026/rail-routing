class Router
  class StationNotFound < StandardError; end
  class SearchQueue
    def initialize
      @q = []
    end

    def enqueue item
      @q << item
    end

    def dequeue
      @q.shift
    end

    def has_item?
      !@q.empty?
    end
  end

  SearchItem = Struct.new(:station, :line_code, :from_item)

  def initialize station_map
    @station_map = station_map
  end

  def route from:, to:
    from_station = find_station!(@station_map, from)
    to_station = find_station!(@station_map, to)

    hit_item = bfs(from_station, to_station)
    return nil unless hit_item

    list_plan(hit_item)
  end

  def find_station! map, name
    s = map.find_station(name)
    raise StationNotFound, "Station `#{name}` can not be found in the given map" unless s
    s
  end
  private :find_station!

  def bfs from_station, to_station
    searched_station_map = { from_station => true }
    q = SearchQueue.new
    hit = nil

    q.enqueue(SearchItem.new(from_station, nil, nil))
    while q.has_item?
      item = q.dequeue
      if item.station == to_station
        hit = item
        break
      end

      item.station.connections.each do |conn|
        neb_station = conn.station
        line_code = conn.line_code
        next if searched_station_map[neb_station]
        searched_station_map[neb_station] = true
        q.enqueue(SearchItem.new(neb_station, line_code, item))
      end
    end

    hit
  end
  private :bfs

  def list_plan hit_item
    plan = []
    item = hit_item
    while item
      plan.unshift([item.station, item.line_code])
      item = item.from_item
    end
    plan
  end
  private :list_plan
end
