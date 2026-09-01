# frozen_string_literal: true

class Frame
  attr_reader :shot_group, :frame_num

  def initialize(shot_group, frame_num)
    @shot_group = shot_group
    @frame_num = frame_num
  end

  def score(frames)
    base = @shot_group.sum
    next_frame = next_frame(frames)
    bonus = if strike?
              next_frame.strike? ? (10 + next_frame.next_frame(frames).shot_group[0]) : next_frame.shot_group.sum
            elsif spare?
              next_frame.shot_group[0]
            else
              0
            end
    base + bonus
  end

  def strike?
    @shot_group == [10, 0]
  end

  def spare?
    @shot_group.sum == 10 && !strike?
  end

  def next_frame(frames)
    return Frame.new([0], @frame_num + 1) unless frames[@frame_num - 1] == self

    frames[@frame_num]
  end
end
