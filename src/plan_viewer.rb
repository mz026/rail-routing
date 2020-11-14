module PlanViewer
  NOT_FOUND_MSG = "No suitable route can be found. 😢😢"
  class << self
    def print_time_routes results
      if results.empty?
        puts NOT_FOUND_MSG
        return
      end

      results.each do |res|
        puts "Time: #{res[:time]}"
        print_plan(res[:plan])
      end
    end

    def print_route plans
      if plans.empty?
        puts NOT_FOUND_MSG
        return
      end

      plans.each {|pl| print_plan(pl)}
    end

    def print_plan stations
      puts "Station Travelled: #{stations.count - 1}"
      puts "Route: #{stations.map(&:station_code).join(' -> ')}"
      puts ""
      puts "Instructions:"

      stations.each_with_index do |st, idx|
        next_st = stations[idx + 1]
        next unless next_st

        if st.line_code == next_st.line_code
          puts "Take #{st.line_code} from #{st.name}(#{st.station_code}) to #{next_st.name}(#{next_st.station_code})"
        else
          puts "Change from #{st.line_code} to #{next_st.line_code}"
        end
      end
      puts "Arrived!! 🥳🥳🥳"
    end
    private :print_plan
  end
end
