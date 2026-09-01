#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/frame'
require_relative './lib/game'

game = Game.new(ARGV[0])
game.total_score
