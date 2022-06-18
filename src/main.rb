# frozen_string_literal: true

# load Mastermind class
require './class/mastermind'

# Define main program
def main
  # Create instance
  mastermind = Mastermind.new

  # Launch game
  mastermind.play_game

  # Show program metadata at game end
  puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
end

# Run program
main
