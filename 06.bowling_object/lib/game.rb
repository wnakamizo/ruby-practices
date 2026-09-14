# frozen_string_literal: true

class Game
  MAX_FRAMES = 9

  attr_reader :all_shots

  def initialize(shots_text)
    @all_shots = shots_text.split(',').map.with_index { |shot, shot_num| Shot.new(shot, shot_num) }
  end

  def total_score
    frames = to_frames
    total_score = frames.sum { |frame| frame.score(all_shots) }
    puts total_score
  end

  private

  def to_frames
    start_index = 0
    (0..MAX_FRAMES).map do |frame_num|
      frame = to_frame(frame_num, start_index)
      start_index += all_shots[start_index].strike? ? 1 : 2
      frame
    end
  end

  def to_frame(frame_num, start_index)
    first_shot = all_shots[start_index]
    second_shot = all_shots[start_index + 1] unless frame_num < MAX_FRAMES && first_shot.strike?
    third_shot = all_shots[start_index + 2] if frame_num == MAX_FRAMES
    Frame.new(frame_num, MAX_FRAMES, first_shot, second_shot, third_shot)
  end
end
