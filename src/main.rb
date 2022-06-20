# frozen_string_literal: true

# load Mastermind class
require './class/mastermind'

# # load math module for percent function
# require './module/math_extend'

# Define main program
def main
  # Create instance
  mastermind = Mastermind.new

  # Launch game
  mastermind.play_game

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
