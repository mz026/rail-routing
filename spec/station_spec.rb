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
    it 'connects the stations and reflects on the #get_neighbors' do
      s1 = Station.create('NS', 1, 'Jurong East', '10 March 1990')
      s2 = Station.create('NS', 2, 'Bukit Batok', '10 March 1990')
      Station.connect(s1, s2)

      expect(s1.get_neighbors).to include(s2)
      expect(s2.get_neighbors).to include(s1)
    end
  end
end
