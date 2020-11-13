module TimeConfig
  class << self
    def config time
      if peak_hours?(time)
        {
          line_weight_map: {
            'NS' => 12,
            'NE' => 12,
            '__default' => 10,
          },
          line_changing_cost: 15,
          excluded_lines: []
        }
      elsif night_hours?(time)
        {
          line_weight_map: {
            'TE' => 8,
            '__default' => 10,
          },
          line_changing_cost: 10,
          excluded_lines: ['DT', 'CG', 'CE']
        }
      else
        {
          line_weight_map: {
            'DT' => 8,
            'TE' => 8,
            '__default' => 10,
          },
          line_changing_cost: 10,
          excluded_lines: []
        }
      end
    end

    def peak_hours? time
      ![6, 0].include?(time.wday) && [6, 7, 8, 18, 19, 20].include?(time.hour)
    end
    private :peak_hours?

    def night_hours? time
      time.hour < 6 && time.hour > 22
    end
    private :night_hours?
  end
end
