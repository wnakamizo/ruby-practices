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
  entries = build_entries(names)
  puts build_padded_rows(entries, options, width)
end

def parse_options(argv)
  options = { lines: false, words: false, bytes: false }
  opt = OptionParser.new
  opt.on('-l') { |v| options[:lines] = v }
  opt.on('-w') { |v| options[:words] = v }
  opt.on('-c') { |v| options[:bytes] = v }
  names = opt.parse(argv)

  options.transform_values! { true } if options.values.none?
  [options, names]
end

def build_entries(names)
  entries = []
  names.each do |name|
    content = name == STDIN_NAME ? $stdin.read : File.read(name)
    lines = content.lines.size
    words = content.split.size
    bytes = content.bytesize

    entries << { name: name, lines: lines, words: words, bytes: bytes }
  end
  add_total(entries) if entries.size >= 2
  entries
end

def add_total(entries)
  total_lines = entries.sum { |entry| entry[:lines] }
  total_words = entries.sum { |entry| entry[:words] }
  total_bytes = entries.sum { |entry| entry[:bytes] }

  entries << { name: 'total', lines: total_lines, words: total_words, bytes: total_bytes }
end

def build_padded_rows(entries, options, width = nil)
  keys = options.select { |_, flag| flag }.keys
  single_count = keys.one? && entries.one?
  max_size = single_count ? 0 : entries[-1][:bytes].to_s.size
  width = width.nil? ? max_size : [width, max_size].max
  entries.map do |entry|
    padded_counts = entry.values_at(*keys).map { |count| count.to_s.rjust(width) }
    [*padded_counts, entry[:name]].join(' ')
  end
end

main
