# frozen_string_literal: true

class Frame
  attr_reader :frame_num, :shots

  def initialize(frame_num, first_shot, second_shot = nil, third_shot = nil)
    @frame_num = frame_num
    @shots = [first_shot, second_shot, third_shot].compact
  end

  def score(all_shots)
    pins_knocked_down + additive_score(all_shots)
  end

  private

  def additive_score(all_shots)
    return 0 if last_frame?

    if strike?
      shots[0].next_n_shots(all_shots, 2).sum(&:pin_count)
    elsif spare?
      shots[1].next_n_shots(all_shots, 1)[0].pin_count
    else
      0
    end
  end

  def pins_knocked_down
    shots.sum(&:pin_count)
  end

  def strike?
    shots[0].strike?
  end

  def spare?
    pins_knocked_down == Game::MAX_PINS && !strike?
  end

  def last_frame?
    frame_num == Game::MAX_FRAMES
  end
end
