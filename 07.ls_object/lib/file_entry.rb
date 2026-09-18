# frozen_string_literal: true

require 'date'
require 'etc'

class FileEntry
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

  attr_reader :name

  def initialize(name)
    @name = name
    @stat = File.lstat(name)
  end

  def block_size
    @stat.blocks
  end

  def mode
    mode_octals = @stat.mode.to_s(8).rjust(6, '0')
    file_type = FILE_TYPE[mode_octals[0..1]]
    permissions = mode_octals[3, 3].chars.map { |octal_digit| PERMISSION_TABLE[octal_digit] }.join
    setuid, setgid, sticky = SPECIAL_PERMISSION_TABLE[mode_octals[2]]
    permissions[2] = replace_with_special_bit(permissions[2], setuid, 's')
    permissions[5] = replace_with_special_bit(permissions[5], setgid, 's')
    permissions[8] = replace_with_special_bit(permissions[8], sticky, 't')
    file_type + permissions
  end

  def nlink
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getpwuid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def timestamp
    mtime = @stat.mtime
    mtime.year == Date.today.year ? mtime.strftime('%b %d %H:%M') : mtime.strftime('%b %d  %Y')
  end

  private

  def replace_with_special_bit(char, special_permission_flag, replacement_char)
    return char unless special_permission_flag

    char == 'x' ? replacement_char : replacement_char.upcase
  end
end
