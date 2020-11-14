module PlanViewer
  class << self
    def print_time_routes results
      results.each do |res|
        puts "Time: #{res[:time]}"
        print_plan(res[:plan])
      end
    end

    def print_route plans
      plans.each {|pl| print_plan(pl)}
    end

    def print_plan plan
      plan.each_with_index do |station|
        puts "#{station.name}(#{station.station_code})"
      end
    end
    private :print_plan
  end
end
