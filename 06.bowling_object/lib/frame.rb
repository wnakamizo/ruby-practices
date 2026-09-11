# frozen_string_literal: true

class Frame
  attr_reader :frame_num, :first_shot, :second_shot, :third_shot

  def initialize(frame_num, first_shot, second_shot = nil, third_shot = nil)
    @frame_num = frame_num
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score(shots)
    additive_score = if strike? && !last_frame?
                       first_shot.next_n_shots(shots, 2).sum(&:pin_count)
                     elsif spare? && !last_frame?
                       second_shot.next_n_shots(shots, 1)[0].pin_count
                     else
                       0
                     end
    pins_knocked_down + additive_score
  end

  def pins_knocked_down
    shots = [first_shot, second_shot, third_shot]
    shots.compact.sum(&:pin_count)
  end

  def strike?
    first_shot.strike?
  end

  def spare?
    pins_knocked_down == Game::MAX_PINS && !strike?
  end

  def last_frame?
    frame_num == Game::MAX_FRAMES
  end
end
