#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

STDIN_NAME = ' '

def main
  options, names = parse_options(ARGV)
  if names.empty?
    names = [STDIN_NAME]
    width = 7 if options.values.select(&:itself).size >= 2
  end

  table = build_table(names, options)
  name_column = names.size >= 2 ? [*names, 'total'] : names
  columns = pad(build_count_columns(table, options), width) + [name_column]
  rows = columns.transpose.map { |row| row.join(' ') }
  rows.each { |row| puts row }
end

def parse_options(argv)
  options = { l: false, w: false, c: false }
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  names = opt.parse(argv)

  options.transform_values! { true } if options.values.none?
  [options, names]
end

def build_table(names, options)
  table = {}
  names.each do |name|
    content = name == STDIN_NAME ? $stdin.read : File.read(name)
    lines = content.lines.size if options[:l]
    words = content.split.size if options[:w]
    bytes = content.bytesize if options[:c]

    table[name] = { lines: lines, words: words, bytes: bytes }
  end
  table
end

def build_count_columns(table, options)
  keys = { l: :lines, w: :words, c: :bytes }
  values = table.values
  options.filter_map do |option, bool|
    next unless bool

    key = keys[option]
    if values.size >= 2
      total = values.sum { |counts| counts[key] }
      values.map { |counts| counts[key] } + [total]
    else
      [values.first[key]]
    end
  end
end

def pad(columns, width = nil)
  max_size = columns.map { |column| column[-1].to_s.size }.max
  width = width.nil? ? max_size : [width, max_size].max
  columns.map { |column| column.map { |count| count.to_s.rjust(width) } }
end

main
