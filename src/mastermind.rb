# frozen_string_literal: true

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

# Post your solution below!

# A simple strategy which is good and computationally much faster than Knuth's is the following (I have programmed both)

# Create the list 1111,...,6666 of all candidate secret codes

# Start with 1122.

# Repeat the following 2 steps:

# 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates 
# all codes that would not have produced the same answer  they were the secret code.

# 2) Pick the first element in the list and use it as new guess.

# This averages no more than 5 guesses.

# This is the Swaszek (1999-2000) strategy that was mentioned in another answer.

# debugger
require 'pry-byebug'

# modules
require './module/game.rb'
require './module/math_extend.rb'

# Board generates a mastermind board
class Board

  #mixins
  include Game
  include MathExtend

  #Instance.attribute reader/accessor, Instance.attribute = newVal writing/accessor
  attr_reader :code_pegs, :key_pegs, :all_secret_codes, :max_turns
  attr_accessor :end_result, :decoding_board, :code_guess, :turn, :codemaker_code, :game_mode

  # Board.new
  def initialize
    game_title
    # https://www.mathsisfun.com/combinatorics/combinations-permutations.html
    @code_pegs = %w[1 2 3 4 5 6]
    @key_pegs = %w[B W]
    @max_turns = 12
    @all_secret_codes = fill_array_4(@code_pegs.length) # possibilities: 6 to the 4
    @game_mode = nil
    @end_result = %w[? ? ? ?]
    @decoding_board = {code_pegs: Array.new(4*max_turns,0), key_pegs: Array.new(4*max_turns,0)}
    @code_guess = nil
    @turn = 0
    @codemaker_code = nil
    draw_board
  end

  def draw_board
    puts "#{@end_result[0]} | #{@end_result[1]} | #{@end_result[2]} | #{@end_result[3]}"
    puts "----------------"

    @max_turns.downto(0) do | i |
      puts "#{@decoding_board[:code_pegs][i-3]} i-3| #{@decoding_board[:code_pegs][i-2]} i-2| #{@decoding_board[:code_pegs][i-1]} i-1| #{@decoding_board[:code_pegs][i]} i|| #{@decoding_board[:key_pegs][i-3]}i-3#{@decoding_board[:key_pegs][i-2]}i-2#{@decoding_board[:key_pegs][i-1]}i-1#{@decoding_board[:key_pegs][i]}i | Row #{i}"
      if i >= 1
        puts "-----------------------"
      end
    end

    puts "-----------------------"
    puts "1  2  3  4"
    puts "5  6  7  8"
    puts
  end

  def insert_code_guess(position)
    @decoding_board[position] = @code_guess
    puts "Inserted at row #{position%12} column #{position%4}"
    puts
    @turn += 1
  end

  def update_board(position)
    insert_code_guess(position)
    draw_board
  end

  def play_rounds(game_mode)
    case mode
      when 1
        play_as_codecracker()
      when 2 
        play_as_codemaker()
      when 3
        cpu_vs_cpu()
    end
  end

  def reset_game_values
    puts 'New Game!'
    puts

    @end_result = %w[? ? ? ?]
    @decoding_board = {code_pegs: Array.new(4*max_turns,0), key_pegs: Array.new(4*max_turns,0)}
    @code_guess = nil
    @turn = 0
    @codemaker_code = nil
    draw_board
  end

  def play_as_codecracker()
    loop do
      until empty_cell?(@player1_position)
        puts 'Player 1 turn'
        puts
        @player1_position = gets.chomp.to_i
        unless empty_cell?(@player1_position)
          puts 'Already occupied'
        end
      end

      update_board(@player1_position)
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
        unless empty_cell?(@player2_position)
          puts 'Already occupied' 
        end
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

  def play_as_codemaker()
    puts
  end

  def cpu_vs_cpu()
    puts
  end

  def select_game_mode
    choice = nil
    puts "Select game mode"
    puts
    puts "[1]: Codecracker"
    puts "[2]: Codemaker"
    puts "[3]: Computer VS Computer"

    loop do
      choice = gets.chomp._to_i
      if choice == 1 || choice == 2 || choice == 3
        break 
      end
      puts "Input numbers 1, 2 or 3" 
    end
    choice
  end

  def play_game
    loop do
      game_mode = select_game_mode
      play_rounds(game_mode)
      unless replay_game?
        break 
      end

      reset_game_values
    end
    puts 'Game ended'
  end

  def winner?(plr)
    board = @current_board
    # check horizontal win
    i = 0
    loop do
      if board[i] == plr && board[i + 1] == plr && board[i + 2] == plr
        return true
      end

      if i >= 6
        break
      end

      i += 3
    end
    i = 0
    # check vertical win
    loop do

      if board[i] == plr && board[i + 3] == plr && board[i + 6] == plr
        return true
      end

      if i >= 2
        break
      end

      i += 1
    end

    # check diagonal win
    if (board[0] == plr &&
      board[4] == plr &&
      board[8] == plr) ||
       board[2] == plr &&
       board[4] == plr &&
       board[6] == plr
      return true
    end

    false
  end
end

mastermind = Board.new
mastermind.play_game

puts __FILE__
puts "lines of code: " + __LINE__