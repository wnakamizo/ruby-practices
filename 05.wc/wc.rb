#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options, names = parse_options(ARGV)
  if names.empty?
    names = ['']
    contents = [$stdin.read]
    width = 7 if options.values.select(&:itself).size >= 2
  end

  table = build_table(names, options, contents)
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

def build_table(names, options, contents = nil)
  table = {}
  names.each { |name| table[name.to_sym] = { lines: nil, words: nil, bytes: nil } }
  register(names, :lines, table, contents) { |content| content.lines.size } if options[:l]
  register(names, :words, table, contents) { |content| content.split.size } if options[:w]
  register(names, :bytes, table, contents, &:bytesize) if options[:c]
  table
end

def register(names, key, table, contents = nil)
  names.each_with_index do |name, index|
    content = contents.nil? ? File.read(name) : contents[index]
    table[name.to_sym][key] = yield(content)
  end
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
