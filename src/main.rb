# load Mastermind class
require './class/mastermind'

# Define main program
def main
  # Create instance
  mastermind = Mastermind.new

  # Launch game
  mastermind.play_game

  # Show program metadata at game end
  puts __FILE__
  puts 'lines of code: '
  p __LINE__
end

# Run program
main
