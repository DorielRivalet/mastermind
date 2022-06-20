# frozen_string_literal: true

# load Mastermind class
require './class/mastermind'

# # load math module for percent function
# require './module/math_extend'

# Define main program
def main
  # Toggle benchmark
  benchmark = false

  # Set benchmark tries
  max_tries = 1000

  # Create instance
  mastermind = Mastermind.new

  # Launch game
  mastermind.play_game(benchmark, max_tries)

  puts "Total rounds: #{mastermind.total_rounds}"
  puts "Losses: #{mastermind.losses}"
  puts "Wins: #{mastermind.wins}"
  puts "Percentage Won: #{mastermind.percent(mastermind.wins, mastermind.total_rounds, 4)}"

  # Show program metadata at game end
  puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
end

# Run program
main
