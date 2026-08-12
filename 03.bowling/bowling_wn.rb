#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',')
scores = shots.map { |shot| shot == 'X' ? 10 : shot.to_i }
current_frame = 1
first_shot = true
strike_bonus = 0
spare_bonus = 0
base_score = 0
scores.each_with_index do |score, i|
  base_score += score
  if score == 10 && first_shot
    strike_bonus += scores[i + 1] + scores[i + 2]
    current_frame += 1
  elsif first_shot
    spare_bonus += scores[i + 2] if score + scores[i + 1] == 10
    first_shot = false
  else
    current_frame += 1
    first_shot = true
  end
  break if current_frame == 11
end

total_score = base_score + spare_bonus + strike_bonus
puts total_score
