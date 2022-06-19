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
  def swaszek
    # Create the list 1111,...,6666 of all candidate secret codes
    # @all_permutations_per_turn = @options.permutation(@slots).to_a

    # Start with 1122.
    return '1122' if @turn == 1

    fill_code_pegs
  end

  # @current_slot - 3, -2, -1, @current_slot

  # def filter_candidates(candidates)
  #   new_candidates = candidates
  #   new_candidates
  #   # p @code_maker_code
  #   # code_guess.chars.each_with_index do |char, k|
  #   #   k = k.to_i
  #   #   if @code_maker_code.chars[k] == char
  #   #     # p "@code_maker_code.chars[k] #{@code_maker_code.chars[k]} == #{v}"
  #   #     @game_board[:key_pegs][k + @current_slot] = 'R'
  #   #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #   #   elsif @code_maker_code.chars.include?(v)
  #   #     # p "@code_maker_code.chars.find(v) #{v}"
  #   #     @game_board[:key_pegs][k + @current_slot] = 'W'
  #   #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #   #   end
  #   # end
  # end

  # def key_peg_maker()
  #   code_guess.chars.each_with_index do |char, k|
  #     k = k.to_i
  #     if @code_maker_code.chars[k] == char
  #         # p "@code_maker_code.chars[k] #{@code_maker_code.chars[k]} == #{v}"
  #       @game_board[:key_pegs][k + @current_slot] = 'R'
  #         # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #     elsif @code_maker_code.chars.include?(v)
  #         # p "@code_maker_code.chars.find(v) #{v}"
  #       @game_board[:key_pegs][k + @current_slot] = 'W'
  #         # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #     end
  #   end
  # end

  def produce_same_answer?(candidate_code, current_key_pegs)
    key_pegs = ''
    candidate_code.each_with_index do |char, key|
      key = key.to_i
      key_pegs += create_key_peg(char, key)
    end
    p "candidate_code #{candidate_code}, current_key_pegs #{current_key_pegs}, key_pegs #{key_pegs}, current_key_pegs == key_pegs #{current_key_pegs == key_pegs}"
    current_key_pegs == key_pegs
  end

  def create_key_peg(char, key)
    return 'R' if @code_maker_code.chars[key] == char

    return 'W' if @code_maker_code.chars.include?(char)

    '0'
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
  # def check_zeroes
  #   numbers_to_remove = []
  #   # previous code guess
  #   @code_guess.chars.each_with_index do |number, k|
  #     next if numbers_to_remove.includes?(number)

  #     numbers_to_remove.push(number) if @game_board[:key_pegs][k + @current_slot] == '0'
  #   end
  #   # while current_key_pegs.include?("0")
  #   #   if @game_board[:key_pegs][k+@current_slot] == "0"
  #   #     possible_code[k] = possible_code[k] - v
  #   #     p possible_code
  #   #     next
  #   #   end
  #   # end
  #   numbers_to_remove
  # end

  # # first insert the numbers that got red key pegs in their slots
  # # then do possible_candidates = check numbers to remove
  # # then

  # def prune_keys(check_zeroes, check_red_key_pegs, check_white_key_pegs)
  #   numbers_to_remove = check_zeroes
  #   numbers_to_include = [check_black_key_pegs, check_white_key_pegs]
  #   current_key_pegs.each_with_index do |_current_key_peg, k|
  #     k = k.to_i
  #     check_zeroes()
  #     if @game_board[:key_pegs][k + @current_slot] == 'R'
  #       possible_code[k] = v
  #     elsif @game_board[:key_pegs][k + @current_slot] == 'W'
  #       possible_code[k] = []
  #     end
  #   end
  # end

  # def check_red_key_pegs
  #   numbers_to_remove = []
  #   # previous code guess
  #   @code_guess.chars.each_with_index do |number, k|
  #     next if numbers_to_remove.includes?(number)

  #     numbers_to_remove.push(number) if @game_board[:key_pegs][k + @current_slot] == '0'
  #   end
  #   # while current_key_pegs.include?("0")
  #   #   if @game_board[:key_pegs][k+@current_slot] == "0"
  #   #     possible_code[k] = possible_code[k] - v
  #   #     p possible_code
  #   #     next
  #   #   end
  #   # end
  #   numbers_to_remove
  # end

  # def check_white_key_pegs
  # end

  def fill_code_pegs
    # possible_code = Array.new(@slots, @options)
    # p possible_code
    current_key_pegs = @game_board[:key_pegs][@current_slot - 4].to_s + @game_board[:key_pegs][@current_slot - 3].to_s + @game_board[:key_pegs][@current_slot - 2].to_s + @game_board[:key_pegs][@current_slot - 1].to_s
    p "@current_slot #{@current_slot} current_key_pegs from row #{@turn - 1}: #{current_key_pegs} turn: #{@turn}"
    # possible_candidates = prune_keys(check_zeroes, check_blacks, check_whites)

    # 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates
    # all codes that would not have produced the same answer IF they were the secret code.
    new_possible_candidates = @possible_candidates.select { |v| !produce_same_answer?(v, current_key_pegs) }
    @possible_candidates = new_possible_candidates
    # possible_candidates = possible_candidates.filter
    p "@possible_candidates size #{@possible_candidates.length} all_candidates #{@all_permutations_per_turn.length}"
    # Pick the first element in the list and use it as new guess.
    puts 'empty array' if @possible_candidates.empty?
    @possible_candidates[0].join('') unless @possible_candidates.empty?
    # '1233'
    # p "turn: #{@turn}, candidates: #{candidates}, possible_code #{possible_code}"
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
  #     @game_board[:key_pegs][k + @current_slot] = 'R'
  #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #   elsif @code_maker_code.chars.include?(char)
  #     # p "@code_maker_code.chars.find(char) #{char}"
  #     @game_board[:key_pegs][k + @current_slot] = 'W'
  #     # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
  #   end
  # end
end
