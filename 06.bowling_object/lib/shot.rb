# frozen_string_literal: true

class Shot
  attr_reader :throw_num
  
  def initialize(pins, throw_num)
    @pins = pins
    @throw_num = throw_num
  end

  def pin_count
    strike? ? 10 : @pins.to_i
  end

  def strike?
    @pins == 'X'
  end
end
