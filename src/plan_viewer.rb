module PlanViewer
  def self.print_on_console plan, time = nil
    puts "Total time required: #{time}\n\n" if time

    plan.each_with_index do |st, i|
      station, line_code = st
      line_code = plan[i + 1][1] unless line_code

      puts "#{station.name}(#{station.station_code(line_code)})"
    end
  end
end
