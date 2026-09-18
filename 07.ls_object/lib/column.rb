# frozen_string_literal: true

class Column
  def initialize(values)
    @values = values
  end

  def width
    @values.map { |value| value.to_s.size }.max || 0
  end

  def justify
    col_width = width
    @values.map { |value| pad(value, col_width) }
  end

  private

  def pad(value, col_width)
    return nil if value.nil?

    value.is_a?(Numeric) ? value.to_s.rjust(col_width) : value.to_s.ljust(col_width)
  end
end
