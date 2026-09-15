# frozen_string_literal: true

class Frame
  def initialize(shots, last_frame)
    @shots = shots
    @last_frame = last_frame
  end

  def score(all_shots)
    pins_knocked_down + additive_score(all_shots)
  end

  private

  attr_reader :shots

  def additive_score(all_shots)
    return 0 if @last_frame

    if strike?
      all_shots[shots[0].throw_num + 1, 2].sum(&:pin_count)
    elsif spare?
      all_shots[shots[1].throw_num + 1].pin_count
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
    pins_knocked_down == 10 && !strike?
  end
end
