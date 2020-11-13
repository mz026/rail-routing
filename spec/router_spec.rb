require_relative '../src/station'
require_relative '../src/router'

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
      a1 = m.add('A', 1, 'A1')
      a2 = m.add('A', 2, 'Hub')
      a3 = m.add('A', 3, 'A3')
      Station.connect(a1, a2)
      Station.connect(a2, a3)

      b1 = m.add('B', 1, 'B1')
      b2 = m.add('B', 2, 'Hub')
      b3 = m.add('B', 3, 'B3')
      Station.connect(b1, b2)
      Station.connect(b2, b3)

      m
    end
    it 'returns station list from station_name1 to station_name2' do
      plans = router.route(from: 'A1', to: 'B3')
      expect(plans.map{|pl| pl.map(&:station_code) }).to eq([['A1', 'A2', 'B2', 'B3']])
    end
    it 'returns [] if no suitable plan was found' do
      map.add('C', 1, 'C1')
      plan = router.route(from: 'A1', to: 'C1')

      expect(plan).to eq([])
    end
    it 'raises if from or to station not found' do
      expect {
        router.route(from: 'UNKNOWN', to: 'B3')
      }.to raise_error(Router::StationNotFound)

      expect {
        router.route(from: 'A1', to: 'UNKNOWN')
      }.to raise_error(Router::StationNotFound)
    end
    it 'considers exchange station' do
      m = Station::Map.new
      a1 = m.add('A', 1, 'X')
      a2 = m.add('A', 2, 'Y')
      Station.connect(a1, a2)
      b1 = m.add('B', 1, 'X')
      b2 = m.add('B', 2, 'Y')
      Station.connect(b1, b2)

      plans = Router.new(m).route(from: 'X', to: 'Y')
      expect(plans.length).to eq(2)
      expect(plans.map {|pl| pl.map(&:station_code)}).to match_array([
        ['A1', 'A2'],
        ['B1', 'B2'],
      ])
    end
  end

  describe '#time_route(from:, to:, line_weight_map:, line_changing_cost:)' do
    let(:date) { '10 March 1990' }
    let(:router) { Router.new(map) }
    let(:map) do
      m = Station::Map.new
      a1 = m.add('A', 1, 'station1')
      a2 = m.add('A', 2, 'station2')
      a3 = m.add('A', 3, 'station3')
      a4 = m.add('A', 4, 'station4')
      Station.connect(a1, a2)
      Station.connect(a2, a3)
      Station.connect(a3, a4)

      b2 = m.add('B', 2, 'station2')
      b4 = m.add('B', 4, 'station4')
      Station.connect(b2, b4)
      m
    end
    it 'calculates route based on weights' do
      results = router.time_route(
        from: 'station1',
        to: 'station4',
        line_weight_map: { 'A' => 5, 'B' => 10 },
        line_changing_cost: 8
      )
      expect(results.map{|r| r[:plan].map(&:station_code) }).to eq([['A1', 'A2', 'A3', 'A4']])
      expect(results.map{|r| r[:time]}).to eq([ 15 ])
    end
    it 'considers line changing cost' do
      results = router.time_route(
        from: 'station1',
        to: 'station4',
        line_weight_map: { 'A' => 5, 'B' => 2 },
        line_changing_cost: 3
      )
      expect(results.map{|r| r[:plan].map(&:station_code) }).to eq([['A1', 'A2', 'B2', 'B4']])
      expect(results.map {|r| r[:time]}).to eq([10])
    end
    it 'allows default weight by key `__default`' do
      results = router.time_route(
        from: 'station1',
        to: 'station4',
        line_weight_map: { 'A' => 5, '__default' => 2 },
        line_changing_cost: 3
      )
      expect(results.map{|r| r[:plan].map(&:station_code) }).to eq([['A1', 'A2', 'B2', 'B4']])
      expect(results.map {|r| r[:time]}).to eq([10])
    end
    it 'returns [] if no suitable route' do
      map.add('C', 1, 'unlinked')
      results = router.time_route(
        from: 'station1',
        to: 'unlinked',
        line_weight_map: { 'A' => 5, 'B' => 10, 'C' => 1 },
        line_changing_cost: 8
      )
      expect(results).to eq([])
    end
  end
end
