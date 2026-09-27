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
  rows = build_padded_rows(table, width)
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
  add_total(table, options) if table.size >= 2
  table
end

def add_total(table, options)
  total_lines = table.values.sum { |counts| counts[:lines] } if options[:l]
  total_words = table.values.sum { |counts| counts[:words] } if options[:w]
  total_bytes = table.values.sum { |counts| counts[:bytes] } if options[:c]

  table['total'] = { lines: total_lines, words: total_words, bytes: total_bytes }
end

def build_padded_rows(table, width = nil)
  max_size = table.values[-1].values.compact.max.to_s.size
  width = width.nil? ? max_size : [width, max_size].max
  table.map do |name, counts|
    padded_counts = counts.values.filter_map { |count| count.nil? ? nil : count.to_s.rjust(width) }
    padded_counts.push(name).join(' ')
  end
end

main
