#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'
require_relative './lib/list'
require_relative './lib/file_entry'
require_relative './lib/column'
require_relative './lib/column_matrix'

options = { a: false, l: false, r: false }
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
opt.on('-l') { |v| options[:l] = v }
opt.on('-r') { |v| options[:r] = v }
opt.parse!(ARGV)

a_opt = options[:a]
r_opt = options[:r]

files = List.new(a_opt, r_opt)
l_opt = options[:l]
files.ls(l_opt)
