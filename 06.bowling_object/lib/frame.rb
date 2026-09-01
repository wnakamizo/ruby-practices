# frozen_string_literal: true

class Frame
  attr_reader :scores, :frame_num

  def initialize(scores, frame_num)
    @scores = scores
    @frame_num = frame_num
  end

  def score(frames)
    base = @scores.sum
    next_frame = next_frame(frames)
    bonus = if strike?
              next_frame.strike? ? (10 + next_frame.next_frame(frames).scores[0]) : next_frame.scores.sum
            elsif spare?
              next_frame.scores[0]
            else
              0
            end
    base + bonus
  end

  def strike?
    @scores == [10, 0]
  end

  def spare?
    @scores.sum == 10 && !strike?
  end

  def next_frame(frames)
    return [0] unless frames[@frame_num - 1] == self

    frames[@frame_num]
  end
end
