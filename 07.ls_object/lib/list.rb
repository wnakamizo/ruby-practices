# frozen_string_literal: true

class List
  def initialize(a_opt, r_opt)
    file_names = a_opt ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files = file_names.map { |name| FileEntry.new(name) }
    @files = r_opt ? files.reverse : files
  end

  def ls(l_opt)
    rows = l_opt ? build_rows_for_l_opt : build_rows_for_default
    puts rows
  end

  private

  def build_rows_for_default(max_columns = 3)
    return [] if @files.empty?

    rows_count = @files.size.ceildiv(max_columns)
    names = @files.map(&:name)
    entries = names.each_slice(rows_count).to_a
    entries[-1][rows_count - 1] = nil if entries[-1].size != rows_count
    ColumnMatrix.new(entries).justified_rows.map { |row| row.join('  ') }
  end

  def build_rows_for_l_opt
    attributes = collect_attributes
    lines = ColumnMatrix.new(attributes).justified_rows.map { |row| row.join(' ') }
    total_line = "total #{@files.map(&:block_size).sum / 2}"
    [total_line, *lines]
  end

  def collect_attributes
    modes = @files.map(&:mode)
    nlinks = @files.map(&:nlink)
    owners = @files.map(&:owner)
    groups = @files.map(&:group)
    sizes = @files.map(&:size)
    timestamps = @files.map(&:timestamp)
    names = @files.map(&:name)

    [modes, nlinks, owners, groups, sizes, timestamps, names]
  end
end
