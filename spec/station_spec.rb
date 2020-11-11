require_relative '../station'

describe Station do
  describe '::create(line_code, line_num, name, start_date)' do
    it 'returns a station' do
      s = Station.create('NS', 1, 'Jurong East', '10 March 1990')
      expect(s).to be_an_instance_of(Station)
    end
    it 'returns the same instance if the station name is the same' do
      s1 = Station.create('NS', 25, 'City Hall', '12 December 1987')
      s2 = Station.create('EW', 13, 'City Hall', '12 December 1987')
      expect(s1).to eq(s2)
    end
  end

  describe '::connect(station1, station2)' do
    let(:date) { '10 March 1990' }
    def create_hub
      s1 = Station.create('L1', 1, 'A', date)
      s2 = Station.create('L1', 2, 'B', date)
      s3 = Station.create('L1', 3, 'C', date)
      Station.connect(s1, s2)
      Station.connect(s2, s3)

      s4 = Station.create('L2', 1, 'X', date)
      s5 = Station.create('L2', 2, 'B', date)
      s6 = Station.create('L2', 2, 'Z', date)
      Station.connect(s4, s5)
      Station.connect(s5, s6)

      s2
    end
    it 'connects the stations and reflects on the #get_neighbors' do
      s1 = Station.create('NS', 1, 'Jurong East', date)
      s2 = Station.create('NS', 2, 'Bukit Batok', date)
      Station.connect(s1, s2)

      expect(s1.get_neighbors).to include(s2)
      expect(s2.get_neighbors).to include(s1)
    end
    it 'returns the neighbor stations' do
      expect(create_hub.get_neighbors.map(&:name)).to match_array(['A', 'C', 'X', 'Z'])
    end
    it 'reflects line stops' do
      expect(create_hub.line_stops.map {|l| [l.line_code, l.line_number]}).to match_array([
        ['L1', 2], ['L2', 2]
      ])
    end
  end

end
