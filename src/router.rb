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

  SearchItem = Struct.new(:station, :from_item)

  def initialize station_map
    @station_map = station_map
  end

  def route from:, to:
    from_stations = find_stations!(@station_map, from)
    to_stations = find_stations!(@station_map, to)

    plans = []
    from_stations.each do |from_s|
      to_stations.each do |to_s|
        hit_item = bfs(from_s, to_s)
        plans << create_bfs_path(hit_item) if hit_item
      end
    end

    min_len = plans.map(&:length).min
    plans.select {|pl| pl.length == min_len}
  end

  def find_stations! map, name
    s = map.find_stations(name)
    if s.empty?
      raise StationNotFound, "Station `#{name}` can not be found in the given map"
    end
    s
  end
  private :find_stations!

  def bfs from_station, to_station
    searched_station_map = { from_station => true }
    q = SearchQueue.new

    hit = nil

    q.enqueue(SearchItem.new(from_station, nil))
    while q.has_item?
      item = q.dequeue
      if item.station == to_station
        hit = item
        break
      end

      item.station.neighbors.each do |neb_station|
        next if searched_station_map[neb_station]
        searched_station_map[neb_station] = true
        q.enqueue(SearchItem.new(neb_station, item))
      end
    end

    hit
  end
  private :bfs

  def create_bfs_path hit_item
    plan = []
    item = hit_item
    while item
      plan.unshift(item.station)
      item = item.from_item
    end
    plan
  end
  private :create_bfs_path

  def time_route from:, to:, line_weight_map:, line_changing_cost:
    from_station = find_station!(@station_map, from)
    to_station = find_station!(@station_map, to)

    dijkstra(from_station, to_station, line_weight_map, line_changing_cost)
  end

  def dijkstra from_station, to_station, line_weight_map, line_changing_cost
    d_map = {
      from_station => { parent: nil, cost: 0, from_line: nil, finished: false }
    }

    station = find_min_unprocessed_station(d_map)
    while station && !(d_map[to_station.name] && d_map[to_station.name][:finished])
      station_data = d_map[station]
      station.connections.each do |c|
        cost = calculate_cost(station_data, c.line_code, line_weight_map, line_changing_cost)
        next if d_map[c.station] && d_map[c.station][:cost] < cost

        d_map[c.station] = {
          parent: station,
          cost: cost,
          from_line: c.line_code,
          finished: false
        }
      end
      station_data[:finished] = true
      station = find_min_unprocessed_station(d_map)
    end

    if d_map[to_station] && d_map[to_station][:finished]
      [
        calculate_path(d_map, to_station),
        d_map[to_station][:cost]
      ]
    else
      [ nil, nil ]
    end
  end
  private :dijkstra

  def find_min_unprocessed_station d_map
    unfinished = d_map.to_a.filter {|_, data| !data[:finished]}
    return nil if unfinished.empty?
    unfinished.min_by {|_, data| data[:cost]}[0]
  end
  private :find_min_unprocessed_station

  def calculate_cost current_station_data, via_line, line_weight_map, line_changing_cost
    c = current_station_data[:cost] + (line_weight_map[via_line] || line_weight_map['__default'])
    if current_station_data[:from_line] &&
        current_station_data[:from_line] != via_line
      c += line_changing_cost
    end
    c
  end
  private :calculate_cost

  def calculate_path d_map, station
    path = []
    current_station = station

    while current_station
      current_data = d_map[current_station]
      path.unshift([current_station, current_data[:from_line]])
      current_station = current_data[:parent]
    end
    path
  end
  private :calculate_cost
end
