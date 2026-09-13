# frozen_string_literal: true

class Game
  MAX_FRAMES = 9
  MAX_PINS = 10

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
    (0..MAX_FRAMES).map { |frame_num| to_frame(frame_num) }
  end

  def to_frame(frame_num)
    index = first_shot_index_for(frame_num)
    first_shot = all_shots[index]
    second_shot = all_shots[index + 1] unless frame_num < MAX_FRAMES && first_shot.strike?
    third_shot = all_shots[index + 2] if frame_num == MAX_FRAMES
    Frame.new(frame_num, first_shot, second_shot, third_shot)
  end

  def first_shot_index_for(frame_num)
    index = 0
    current_frame_num = 0
    while current_frame_num < frame_num
      index += all_shots[index].strike? ? 1 : 2
      current_frame_num += 1
    end
    index
  end
end
