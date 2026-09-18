# frozen_string_literal: true

class ColumnMatrix
  def initialize(columns)
    @columns = columns.map { |column| Column.new(column) }
  end

  def justified_rows
    @columns.map(&:justify).transpose
  end
end
