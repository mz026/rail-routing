# usage: ruby run.rb 'Holland Village' 'Bugis'

require_relative './src/map_builder'
require_relative './src/router'
require 'csv'

from = ARGV[0]
to = ARGV[1]

arr = CSV.parse(File.read('./assets/StationMap.csv'))[1..-1]

map = MapBuilder.new.build(arr)

router = Router.new(map)
res = router.route(from: from, to: to)

res.each do |st|
  station, line_code = st
  puts "#{station.name}(#{line_code})"
end

