#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

STDIN_NAME = ''

def main
  options, names = parse_options(ARGV)
  if names.empty?
    names = [STDIN_NAME]
    width = 7 if options.values.select(&:itself).size >= 2
  end
  entries = build_entries(names, options)
  puts build_padded_rows(entries, width)
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

def build_entries(names, options)
  entries = []
  names.each do |name|
    content = name == STDIN_NAME ? $stdin.read : File.read(name)
    lines = content.lines.size if options[:l]
    words = content.split.size if options[:w]
    bytes = content.bytesize if options[:c]

    entries << { name: name, lines: lines, words: words, bytes: bytes }
  end
  add_total(entries, options) if entries.size >= 2
  entries
end

def add_total(entries, options)
  total_lines = entries.sum { |entry| entry[:lines] } if options[:l]
  total_words = entries.sum { |entry| entry[:words] } if options[:w]
  total_bytes = entries.sum { |entry| entry[:bytes] } if options[:c]

  entries << { name: 'total', lines: total_lines, words: total_words, bytes: total_bytes }
end

def build_padded_rows(entries, width = nil)
  max_size = entries[-1].values_at(:lines, :words, :bytes).compact.max.to_s.size
  width = width.nil? ? max_size : [width, max_size].max
  entries.map do |entry|
    padded_counts = entry.values_at(:lines, :words, :bytes).compact.map { |count| count.to_s.rjust(width) }
    [*padded_counts, entry[:name]].join(' ')
  end
end

main
