# frozen_string_literal: true

# Specifications
# Build a Mastermind game from the command line where you have 12 turns to guess the secret code,
# starting with you guessing the computer’s random code.
# Think about how you would set this problem up!
# Build the game assuming the computer randomly selects the secret colors and the human player must guess them.
# Remember that you need to give the proper feedback on how good the guess was each turn!
# Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or the guesser.
# Build it out so that the computer will guess  you decide to choose your own secret colors.
# You may choose to implement a computer strategy that follows the rules of the game or you can modify these rules.
# If you choose to modify the rules, you can provide the computer additional information about each guess.
# For example, you can start by having the computer guess randomly, but keep the ones that match exactly.
# You can add a little bit more intelligence to the computer player so that,  the computer has guessed the right color but the wrong position,
# its next guess will need to include that color somewhere.
# If you want to follow the rules of the game, you’ll need to research strategies for solving Mastermind, such as this post.

# Pseudocode
# A simple strategy which is good and computationally much faster than Knuth's is the following (I have programmed both)
# Create the list 1111,...,6666 of all candidate secret codes
# Start with 1122.
# Repeat the following 2 steps:
# 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates
# all codes that would not have produced the same answer  they were the secret code.
# 2) Pick the first element in the list and use it as new guess.
# This averages no more than 5 guesses.
# This is the Swaszek (1999-2000) strategy that was mentioned in another answer.

# load superclass
require './class/board'

# Mastermind board game inherits from Board class.
# Board has MathExtend and Game modules included
class Mastermind < Board

  @@board_data = {
    title: "

    | \/| _  _|_ _ _ _ . _  _|
    |  |(_|_)|_(-| ||||| )(_|
  
       ",
    slots: 4,
    options: %w[1 2 3 4 5 6],
    max_turns: 12,
    game_modes: ["Codecracker", "Codemaker", "CPU vs CPU"]
  }

  def play_game
    loop do
      game_mode = select_game_mode_from_array(@game_modes)
      play_rounds(game_mode)
      break unless replay_game?

      reset_game_values
    end
    puts 'Game ended'
  end

  def play_as_codecracker
    loop do
      until empty_cell?(@player1_position)
        puts 'Player 1 turn'
        puts
        @player1_position = gets.chomp.to_i
        puts 'Already occupied' unless empty_cell?(@player1_position)
      end

      update_board(@player1_position)
      # attach debugger
      # binding.pry
      if draw?('X')
        puts 'Draw!'
        break
      end

      if winner?('X')
        puts end_game_msg('X')
        break
      end

      until empty_cell?(@player2_position)
        puts 'Player 2 turn'
        puts
        @player2_position = gets.chomp.to_i
        puts 'Already occupied' unless empty_cell?(@player2_position)
      end

      update_board(@player2_position)

      if draw?('O')
        puts 'Draw!'
        break
      end

      if winner?('O')
        puts end_game_msg('O')
        break
      end
    end
  end

  def play_as_codemaker
    puts
  end

  def cpu_vs_cpu
    puts
  end
end
