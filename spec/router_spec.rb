require_relative '../station'
require_relative '../router'

describe Router do
  describe '::new(station_map)' do
    it 'takes a station map to init' do
      map = Station::Map.new
      Router.new(map)
    end
  end
  describe '#route(from: station_name1, to: station_name2)' do
    let(:date) { '10 March 1990' }
    let(:router) { Router.new(map) }
    let(:map) do
      m = Station::Map.new
      a1 = m.add('A', 1, 'A1', date)
      a2 = m.add('A', 2, 'Hub', date)
      a3 = m.add('A', 3, 'A3', date)
      Station.connect(a1, a2)
      Station.connect(a2, a3)

      b1 = m.add('B', 1, 'B1', date)
      b2 = m.add('B', 2, 'Hub', date)
      b3 = m.add('B', 3, 'B3', date)
      Station.connect(b1, b2)
      Station.connect(b2, b3)

      m
    end
    it 'returns station list from station_name1 to station_name2' do
      plan = router.route(from: 'A1', to: 'B3')
      expect(plan).to eq([
        map.find_station('A1'),
        map.find_station('Hub'),
        map.find_station('B3'),
      ])
    end
  end
end
