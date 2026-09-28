#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'
require_relative './lib/current_directory'
require_relative './lib/file_entry'

options = { a: false, l: false, r: false }
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
opt.on('-l') { |v| options[:l] = v }
opt.on('-r') { |v| options[:r] = v }
opt.parse!(ARGV)

current_directory = CurrentDirectory.new(options[:a], options[:r])
current_directory.ls(options[:l])
