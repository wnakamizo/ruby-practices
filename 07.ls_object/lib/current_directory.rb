# frozen_string_literal: true

class CurrentDirectory
  MAX_COLUMNS = 3

  def initialize(a_opt)
    @file_names = a_opt ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def ls(l_opt, r_opt)
    l_opt ? list_file_attributes(r_opt) : list_filenames(r_opt)
  end

  private

  def list_filenames(r_opt)
    return [] if @file_names.empty?

    max_rows_count = @file_names.size.ceildiv(MAX_COLUMNS)
    names = r_opt ? @file_names.reverse : @file_names
    padded_names = pad(names)
    columns = padded_names.each_slice(max_rows_count).to_a
    columns[-1][max_rows_count - 1] = nil if columns[-1].size != max_rows_count
    columns.transpose.each { |row| puts row.join('  ') }
  end

  def list_file_attributes(r_opt)
    file_entries = build_file_entries
    puts "total #{file_entries.map(&:block_size).sum / 2}"

    file_entries = file_entries.reverse if r_opt
    width_nlink = file_entries.map { |entry| entry.nlink.to_s.size }.max
    width_owner = file_entries.map { |entry| entry.owner.size }.max
    width_group = file_entries.map { |entry| entry.group.size }.max
    width_size = file_entries.map { |entry| entry.size.to_s.size }.max
    file_entries.each { |file_entry| puts file_entry.show_attributes(width_nlink, width_owner, width_group, width_size) }
  end

  def pad(names)
    longest_name_size = @file_names.map(&:size).max
    names.map { |name| name.ljust(longest_name_size) }
  end

  def build_file_entries
    @file_names.map { |name| FileEntry.new(name) }
  end
end
