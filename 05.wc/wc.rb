#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

STDIN_NAME = ''
STDIN_DEFAULT_WIDTH = 7

def main
  options, names = parse_options(ARGV)
  entries = build_entries(names)
  puts build_padded_rows(entries, options)
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
  names_to_read = names.empty? ? [STDIN_NAME] : names
  entries = names_to_read.map do |name|
    content = name == STDIN_NAME ? $stdin.read : File.read(name)
    {
      name: name,
      lines: content.lines.size,
      words: content.split.size,
      bytes: content.bytesize
    }
  end
  entries << calculate_total(entries) if entries.size >= 2
  entries
end

def calculate_total(entries)
  %i[lines words bytes].each_with_object({ name: 'total' }) do |counts, total|
    total[counts] = entries.sum { |entry| entry[counts] }
  end
end

def build_padded_rows(entries, options)
  keys = options.select { |_, flag| flag }.keys
  first_entry = entries.first
  return ["#{first_entry[*keys]} #{first_entry[:name]}"] if keys.one? && entries.one?

  max_digit_count = entries.last[:bytes].to_s.size
  width = first_entry[:name] == STDIN_NAME ? [max_digit_count, STDIN_DEFAULT_WIDTH].max : max_digit_count
  entries.map do |entry|
    padded_counts = entry.values_at(*keys).map { |count| count.to_s.rjust(width) }
    [*padded_counts, entry[:name]].join(' ')
  end
end

main
