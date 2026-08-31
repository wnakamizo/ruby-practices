#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'

FILE_TYPE = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

SPECIAL_PERMISSION_TABLE = {
  '0' => [false, false, false],
  '1' => [false, false, true],
  '2' => [false, true, false],
  '3' => [false, true, true],
  '4' => [true, false, false],
  '5' => [true, false, true],
  '6' => [true, true, false],
  '7' => [true, true, true]
}.freeze

PERMISSION_TABLE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

ColumnLayout = Data.define(:values, :justify)
FileAttributes = Data.define(:block_sizes, :file_modes, :nlinks, :owners, :groups, :sizes, :timestamps)

def pad_filenames(files)
  longest_filename_length = files.map(&:length).max
  files.map { |file| file.ljust(longest_filename_length) }
end

def build_rows_for_default_option(files, max_columns = 3)
  return [] if files.empty?

  max_rows_count = files.size.ceildiv(max_columns)
  columns = files.each_slice(max_rows_count).to_a
  columns[-1][max_rows_count - 1] = nil if columns[-1].size != max_rows_count
  columns.transpose.map { |row| row.join('  ') }
end

def display(rows)
  rows.each { |row| puts row }
end

def replace_with_special_bit(char, special_permission_flag, replacement_char)
  return char unless special_permission_flag

  char == 'x' ? replacement_char : replacement_char.upcase
end

def build_file_mode(stat)
  mode_octals = stat.mode.to_s(8).rjust(6, '0')
  file_type = FILE_TYPE[mode_octals[0..1]]
  permissions = mode_octals[3, 3].chars.map { |octal_digit| PERMISSION_TABLE[octal_digit] }.join
  setuid, setgid, sticky = SPECIAL_PERMISSION_TABLE[mode_octals[2]]
  permissions[2] = replace_with_special_bit(permissions[2], setuid, 's')
  permissions[5] = replace_with_special_bit(permissions[5], setgid, 's')
  permissions[8] = replace_with_special_bit(permissions[8], sticky, 't')
  file_type + permissions
end

def collect_file_attributes(files)
  block_sizes, file_modes, nlinks, owners, groups, sizes, timestamps = Array.new(7) { [] }
  files.each do |file|
    stat = File.lstat(file)
    block_sizes << stat.blocks
    file_modes << build_file_mode(stat)
    nlinks << stat.nlink
    owners << Etc.getpwuid(stat.uid).name
    groups << Etc.getgrgid(stat.gid).name
    sizes << stat.size
    stat_mtime = stat.mtime
    timestamps << (stat_mtime.year == Date.today.year ? stat_mtime.strftime('%b %d %H:%M') : stat_mtime.strftime('%b %d  %Y'))
  end
  FileAttributes.new(block_sizes:, file_modes:, nlinks:, owners:, groups:, sizes:, timestamps:)
end

def align_columns(attributes)
  column_layouts = [
    ColumnLayout.new(values: attributes.nlinks, justify: :rjust),
    ColumnLayout.new(values: attributes.owners, justify: :ljust),
    ColumnLayout.new(values: attributes.groups, justify: :ljust),
    ColumnLayout.new(values: attributes.sizes,  justify: :rjust)
  ]
  column_layouts.map do |layout|
    cells = layout.values.map(&:to_s)
    width = cells.map(&:size).max || 0
    cells.map { |cell| cell.public_send(layout.justify, width) }
  end
end

def build_rows_for_l_option(files)
  attributes = collect_file_attributes(files)
  aligned_columns = align_columns(attributes)
  total_line = "total #{attributes.block_sizes.sum / 2}"
  columns = [attributes.file_modes, *aligned_columns, attributes.timestamps, files]
  lines = columns.transpose.map { |row| row.join(' ') }
  [total_line, *lines]
end

a_option = r_option = l_option = false
opt = OptionParser.new
opt.on('-a') { |v| a_option = v }
opt.on('-r') { |v| r_option = v }
opt.on('-l') { |v| l_option = v }
opt.parse!(ARGV)

files = if a_option
          Dir.glob('*', File::FNM_DOTMATCH)
        else
          Dir.glob('*')
        end

files = files.reverse if r_option

rows = if l_option
         build_rows_for_l_option(files)
       else
         padded_files = pad_filenames(files)
         build_rows_for_default_option(padded_files)
       end
display(rows)
