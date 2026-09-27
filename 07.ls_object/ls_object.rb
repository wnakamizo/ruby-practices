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

files = CurrentDirectory.new(options[:a])
files.ls(options[:l], options[:r])
