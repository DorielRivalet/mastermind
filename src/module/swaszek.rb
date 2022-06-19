# frozen_string_literal: true

require './class/mastermind'

# A simple strategy which is good and computationally much faster
# than Knuth's is the following (I have programmed both)
# Create the list 1111,...,6666 of all candidate secret codes
# Start with 1122.
# Repeat the following 2 steps:
# 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates
# all codes that would not have produced the same answer IF they were the secret code.
# 2) Pick the first element in the list and use it as new guess.
# This averages no more than 5 guesses.
# This is the Swaszek (1999-2000) strategy that was mentioned in another answer.
module Swaszek
  # prune keys according to key_pegs
  def swaszek(candidates)
    return '1122' if @turn == 1

    fill_code_pegs(candidates)
  end

  # code_maker 1436
  # guess 2361
  # keys 0www
  # numbers_to_remove = []
  # numbers_to_include = []
  # push 2 number_to_remove array
  # do function unless number_to_remove already found in number_to_remove array
  # possible_code = [%w[1 3 4 5 6], %w[1 3 4 5 6], %w[1 3 4 5 6], %w[1 3 4 5 6]]
  # numbers_to_remove.push(2)
  # next if number_to_remove.includes?(i)
  def check_zeroes(candidates, current_key_pegs)

    #previous code guess
    @code_guess.chars.each_with_index do |k,v|
      next if numbers_to_remove.includes?(v)

      numbers_to_remove.push(v) if 
    end
    arr = current_key_pegs
    while arr.include?("0")
      if @game_board[:key_pegs][k+@current_slot] == "0"
        possible_code[k] = possible_code[k] - v
        p possible_code
        next
      end
    end
  end

  def fill_code_pegs(candidates)
    possible_code = Array.new(@slots, @options)
    p possible_code
    current_key_pegs = [@game_board[:key_pegs][@current_slot],@game_board[:key_pegs][@current_slot+1],@game_board[:key_pegs][@current_slot+2],@game_board[:key_pegs][@current_slot+3]]
    # p "turn: #{@turn}, candidates: #{candidates}, possible_code #{possible_code}"
    current_key_pegs.each_with_index do |current_key_peg, k|
      k = k.to_i
      check_zeroes(candidates, current_key_peg)
      if @game_board[:key_pegs][k+@current_slot] == "R"
        possible_code[k] = v
      elsif @game_board[:key_pegs][k+@current_slot] == "W"
        possible_code[k] = []
      end
    end
    candidates = candidates.filter
    candidates[0].join('')
    # '1233'
  end

  # def swaszek_start
  #   @code_guess = "1122"
  #   # @game_board[:code_pegs][0] = '1' # @code_guess.chars[0]
  #   # @game_board[:code_pegs][1] = '1' # @code_guess.chars[1]
  #   # @game_board[:code_pegs][2] = '2' # @code_guess.chars[2]
  #   # @game_board[:code_pegs][3] = '2' # @code_guess.chars[3]
  # end
    # code_guess.chars.each_with_index do |char, k|
    #   k = k.to_i
    #   if @code_maker_code.chars[k] == char
    #     # p "@code_maker_code.chars[k] #{@code_maker_code.chars[k]} == #{char}"
    #     @game_board[:key_pegs][k + @current_slot] = 'B'
    #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    #   elsif @code_maker_code.chars.include?(char)
    #     # p "@code_maker_code.chars.find(char) #{char}"
    #     @game_board[:key_pegs][k + @current_slot] = 'W'
    #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    #   end
    # end
end
