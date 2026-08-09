#!/usr/bin/env ruby
require "date"
require "optparse"
today = Date.today
month = today.month
year = today.year

opt = OptionParser.new
opt.on('-m MONTH') { |m| month = m.to_i }
opt.on('-y YEAR') { |y| year = y.to_i }
opt.parse!(ARGV)

sub_header = "Su Mo Tu We Th Fr Sa"

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)
month_name = first_date.strftime("%B")
header = "#{month_name} #{year}".center(sub_header.size)

three_spaces = "   "
first_week_indent = three_spaces*(first_date.strftime("%w").to_i)
weeks = (first_date..last_date).slice_before(&:sunday?)
body = weeks.map.with_index do |week, index|
  formatted_week = week.map do |date|
    "%2d" % date.day
  end.join(" ")

  if index.zero?
    formatted_week = first_week_indent + formatted_week
  else
    formatted_week
  end
end

puts [
  header,
  sub_header,
  body
]
