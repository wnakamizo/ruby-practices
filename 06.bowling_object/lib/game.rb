# frozen_string_literal: true

class Game
  MAX_FRAMES = 9

  attr_reader :all_shots

  def initialize(shots_text)
    @all_shots = shots_text.split(',').map.with_index { |pins, throw_num| Shot.new(pins, throw_num) }
  end

  def total_score
    frames = to_frames
    total_score = frames.sum { |frame| frame.score(all_shots) }
    puts total_score
  end

  private

  def to_frames
    start_index = 0
    (MAX_FRAMES + 1).times.map do |frame_num|
      frame = to_frame(frame_num, start_index)
      start_index += all_shots[start_index].strike? ? 1 : 2
      frame
    end
  end

  def to_frame(frame_num, start_index)
    last_frame = frame_num == MAX_FRAMES
    count = if last_frame
              3
            elsif all_shots[start_index].strike?
              1
            else
              2
            end
    shots = all_shots[start_index, count]
    Frame.new(shots, last_frame)
  end
end
