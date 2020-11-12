require_relative '../src/station'

describe Station do
  describe 'Map::add(line_code, line_num, name, start_date)' do
    it 'returns a station' do
      s = Station::Map.new.add('NS', 1, 'Jurong East', '10 March 1990')
      expect(s).to be_an_instance_of(Station)
    end
    it 'returns the same instance if the station name is the same' do
      map = Station::Map.new
      s1 = map.add('NS', 25, 'City Hall', '12 December 1987')
      s2 = map.add('EW', 13, 'City Hall', '12 December 1987')
      expect(s1).to eq(s2)
    end
  end

  describe '::connect(station1, station2, line_code)' do
    let(:date) { '10 March 1990' }
    let(:map) { Station::Map.new }
    def create_hub map
      s1 = map.add('L1', 1, 'A', date)
      s2 = map.add('L1', 2, 'B', date)
      s3 = map.add('L1', 3, 'C', date)
      Station.connect(s1, s2, 'L1')
      Station.connect(s2, s3, 'L1')

      s4 = map.add('L2', 1, 'X', date)
      s5 = map.add('L2', 2, 'B', date)
      s6 = map.add('L2', 2, 'Z', date)
      Station.connect(s4, s5, 'L2')
      Station.connect(s5, s6, 'L2')

      s2
    end
    it 'connects the stations and reflects on the #connections' do
      s1 = map.add('NS', 1, 'Jurong East', date)
      s2 = map.add('NS', 2, 'Bukit Batok', date)
      Station.connect(s1, s2, 'NS')

      expect(s1.connections.map {|c| [c.line_code, c.station.name]}).to include(['NS', s2.name])
      expect(s2.connections.map {|c| [c.line_code, c.station.name]}).to include(['NS', s1.name])
    end
    it 'returns the neighbor stations' do
      expect(create_hub(map).connections.map {|c| [c.line_code, c.station.name]}).to match_array([
        ['L1', 'A'],
        ['L1', 'C'],
        ['L2', 'X'],
        ['L2', 'Z'],
      ])
    end
    it 'reflects line stops' do
      hub = create_hub(map)
      expect(hub.station_code('L1')).to eq('L12')
      expect(hub.station_code('L2')).to eq('L22')
    end
  end

end
