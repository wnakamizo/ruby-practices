#!/usr/bin/env ruby
# frozen_string_literal: true

files = Dir.glob('*')

def pad_filenames(files)
  longest_filename_length = files.map(&:length).max
  files.map { |file| file.ljust(longest_filename_length) }
end

def build_rows(files, max_columns = 3)
  return [] if files.empty?

  max_rows_count = files.size.ceildiv(max_columns)
  columns = files.each_slice(max_rows_count).to_a
  columns[-1][max_rows_count - 1] = nil if columns[-1].size != max_rows_count
  columns.transpose.map { |row| row.join('  ') }
end

def display(rows)
  rows.each { |row| puts row }
end

padded_files = pad_filenames(files)
rows = build_rows(padded_files)
display(rows)
