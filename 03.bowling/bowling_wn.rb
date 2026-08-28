#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',')
scores = shots.map { |shot| shot == 'X' ? 10 : shot.to_i }
current_frame = 1
first_shot = true
total_score = 0
scores.each_with_index do |score, i|
  total_score += score
  if first_shot
    if score == 10
      total_score += scores[i + 1, 2].sum
      current_frame += 1
    else
      total_score += scores[i + 2] if score + scores[i + 1] == 10
      first_shot = false
    end
  else
    current_frame += 1
    first_shot = true
  end
  break if current_frame == 11
end

puts total_score
