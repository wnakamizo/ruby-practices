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
space = " "

month_name = Date.new(year, month, 1).strftime("%B")
total_padding_size = sub_header.size - (month_name.size + year.to_s.size + 1)
left_padding = space*(total_padding_size/2)
if total_padding_size.even?
  right_padding = space*(total_padding_size/2)
else
  right_padding = space*(total_padding_size/2 + 1)
end
header = left_padding + "#{month_name} #{year}" + right_padding

weekday_name = Date.new(year, month, 1).strftime("%a")[0, 2]
first_day_indent = space*(sub_header.index(weekday_name))
days_array = (Date.new(year, month, 1)..Date.new(year, month, -1)).map do |x|
  x.strftime("%e")
end
raw_days_str = first_day_indent + days_array.join(" ")
# Remove delimiters every 21 characters (7 days * 3 chars)
formatted_days_str = raw_days_str.chars.select.with_index(1) do |char, position|
  position % 21 != 0
end.join
body = formatted_days_str.scan(/.{1,#{sub_header.size}}/)

puts [
  header,
  sub_header,
  body
]
