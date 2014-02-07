#!/usr/bin/env ruby
require_relative 'lib/chess_validator'

abort "Invalid input arguments\n\tArg1: board filename\n\tArg2: move filename" if ARGV.length != 2

chess_validator = ChessValidator.new 
chess_validator.build_board ARGV[0]
puts chess_validator.process_moves ARGV[1]
