#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0].split(',')
converted_input = input.map { |shot| shot == 'X' ? 10 : shot.to_i }
frame_numbers = [1.0]
bonus_score_strike = 0
bonus_score_spare = 0
base_score = 0
converted_input.each_with_index do |score, i|
  base_score += converted_input[i]
  if score == 10 && (frame_numbers[-1] % 1).zero?
    bonus_score_strike += converted_input[i + 1] + converted_input[i + 2]
    frame_numbers.push(frame_numbers[-1] + 1.0)
  else
    bonus_score_spare += converted_input[i + 2] if (frame_numbers[-1] % 1).zero? && score + converted_input[i + 1] == 10
    frame_numbers.push(frame_numbers[-1] + 0.5)
  end
  break if frame_numbers[-1] == 11
end

total_score = base_score + bonus_score_spare + bonus_score_strike
puts total_score
