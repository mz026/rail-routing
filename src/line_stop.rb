class LineStop
  attr_reader :line_code, :line_number, :start_date

  def initialize line_code, line_number, start_date
    @line_code = line_code
    @line_number = line_number
    @start_date = start_date
  end
end
