# frozen_string_literal: true

# load Mastermind class
require './class/mastermind'

# load benchmark utility
require 'benchmark'

# # load math module for percent function
# require './module/math_extend'

# Define main program
def main
  # Create instance
  mastermind = Mastermind.new

  # Launch game
  time = Benchmark.measure { mastermind.play_game }
  # https://ruby-doc.org/stdlib-1.9.3/libdoc/benchmark/rdoc/Benchmark.html
  puts "Playtime (user CPU, system CPU , user+system CPU, real time): #{time}"
  puts "Total rounds: #{mastermind.total_rounds}"
  puts "Losses: #{mastermind.losses}"
  puts "Wins: #{mastermind.wins}"
  puts "Winrate: #{mastermind.percent(mastermind.wins, mastermind.total_rounds, 4)}%"
  puts "Average turns: #{mastermind.average_from_array(mastermind.round_ends)}"
  # Show program metadata at game end
  puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
end

# Run program
main
