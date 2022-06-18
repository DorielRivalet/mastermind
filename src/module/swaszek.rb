# frozen_string_literal: true

require './class/mastermind'

# A simple strategy which is good and computationally much faster
# than Knuth's is the following (I have programmed both)
# Create the list 1111,...,6666 of all candidate secret codes
# Start with 1122.
# Repeat the following 2 steps:
# 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates
# all codes that would not have produced the same answer  they were the secret code.
# 2) Pick the first element in the list and use it as new guess.
# This averages no more than 5 guesses.
# This is the Swaszek (1999-2000) strategy that was mentioned in another answer.
module Swaszek
  # prune keys according to keypegs
  def swaszek(keypegs, _candidates)
    if keypegs[0].zero?
      @code_guess = '1122'
      fill_codepegs(@turn)
      return
    end
    fill_codepegs(turn)
  end

  def fill_codepegs(turn)
    if turn == 1
      @game_board[:code_pegs][0] = '1' # @code_guess.chars[0]
      @game_board[:code_pegs][1] = '1' # @code_guess.chars[1]
      @game_board[:code_pegs][2] = '2' # @code_guess.chars[2]
      @game_board[:code_pegs][3] = '2' # @code_guess.chars[3]
    else
    # p @codemaker_code
    # code_guess.chars.each_with_index do |v, k|
    #   k = k.to_i
    #   if @codemaker_code.chars[k] == v
    #     # p "@codemaker_code.chars[k] #{@codemaker_code.chars[k]} == #{v}"
    #     @game_board[:key_pegs][k + @current_slot] = 'B'
    #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    #   elsif @codemaker_code.chars.include?(v)
    #     # p "@codemaker_code.chars.find(v) #{v}"
    #     @game_board[:key_pegs][k + @current_slot] = 'W'
    #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    #   end
    # end

    end
  end
end
