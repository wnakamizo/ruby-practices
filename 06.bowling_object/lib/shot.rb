# frozen_string_literal: true

class Shot
  def initialize(shot, shot_num)
    @shot = shot
    @shot_num = shot_num
  end

  def pin_count
    strike? ? 10 : @shot.to_i
  end

  def strike?
    @shot == 'X'
  end

  def next_n_shots(shots, count)
    shots[@shot_num + 1, count]
  end
end
