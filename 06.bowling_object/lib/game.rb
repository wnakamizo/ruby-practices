# frozen_string_literal: true

class Game
  def initialize(shots_text)
    @shots = shots_text.split(',').flat_map { |shot| shot == 'X' ? [10, 0] : shot.to_i }
  end

  def total_score
    frames = to_frames
    total_score = frames.first(10).sum { |frame| frame.score(frames) }
    puts total_score
  end

  private

  def to_frames
    shot_groups = @shots.each_slice(2).to_a
    shot_groups.map.with_index(1) { |shot_group, frame_num| Frame.new(shot_group, frame_num) }
  end
end
