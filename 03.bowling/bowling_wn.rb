#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0].split(',')
converted_input = input.map { |shot| shot == 'X' ? 10 : shot.to_i }
frame_number = 1
first_shot = true
bonus_score_strike = 0
bonus_score_spare = 0
base_score = 0
converted_input.each_with_index do |score, i|
  base_score += score
  if score == 10 && first_shot
    bonus_score_strike += converted_input[i + 1] + converted_input[i + 2]
    frame_number += 1
  elsif first_shot
    bonus_score_spare += converted_input[i + 2] if score + converted_input[i + 1] == 10
    first_shot = false
  else
    frame_number += 1
    first_shot = true
  end
  break if frame_number == 11
end

total_score = base_score + bonus_score_spare + bonus_score_strike
puts total_score
