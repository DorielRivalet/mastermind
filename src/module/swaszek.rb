# frozen_string_literal: true

# load debugger
require 'pry-byebug'

# load classes
require './class/mastermind'
require './module/math_extend'

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

  def produce_same_answer?(candidate_code)
    # reds and whites
    key_pegs_count = [0, 0]
    candidate_code.each_with_index do |char, key|
      key = key.to_i
      create_key_peg(char, key, key_pegs_count)
    end
    # p "candidate_code #{candidate_code},
    # @current_key_pegs_count #{@current_key_pegs_count}, key_pegs_count #{key_pegs_count}"
    # p "@current_key_pegs_count == key_pegs_count #{@current_key_pegs_count == key_pegs_count}"
    @current_key_pegs_count[0] == key_pegs_count[0] && @current_key_pegs_count[1] == key_pegs_count[1]
  end

  def create_key_peg(char, key, key_pegs_count)
    # 'R'
    if @code_maker_code.chars[key] == char
      key_pegs_count[0] += 1
    # 'W'
    elsif @code_maker_code.chars.include?(char)
      key_pegs_count[1] += 1
    end
  end

  # set number of red and white key pegs
  def set_current_key_pegs_count
    key_pegs_count = [0, 0]
    key_pegs = @game_board[:key_pegs][@current_slot - 4].to_s + @game_board[:key_pegs][@current_slot - 3].to_s + @game_board[:key_pegs][@current_slot - 2].to_s + @game_board[:key_pegs][@current_slot - 1].to_s
    key_pegs.split('').each_with_index do |key_peg, _|
      next if key_peg == '0'

      key_pegs_count[0] += 1 if key_peg == 'R'

      key_pegs_count[1] += 1 if key_peg == 'W'
    end
    key_pegs_count
  end

  def show_pruned_stats(old_possible_candidates, new_possible_candidates)
    pruned = (old_possible_candidates - new_possible_candidates.length)
    partial = (@all_permutations_per_turn.length - @possible_candidates.length)
    total = @all_permutations_per_turn.length
    puts "Pruned #{pruned} keys (#{percent(pruned, total, 2)}%)"
    puts "#{partial}/#{total} total (#{percent(partial, total, 2)}%)\n\n"
  end

  def produce_worse_answer?(candidate_code)
    # reds and whites
    key_pegs_count = [0, 0]
    candidate_code.each_with_index do |char, key|
      key = key.to_i
      create_key_peg(char, key, key_pegs_count)
    end
    @current_key_pegs_count[0] >= key_pegs_count[0] # && @current_key_pegs_count[1] == key_pegs_count[1]
  end

  def fill_code_pegs
    @current_key_pegs_count = set_current_key_pegs_count
    # 1) After you got the answer (number of red and number of white pegs) eliminate from the list of candidates
    # all codes that would not have produced the same answer IF they were the secret code.
    old_possible_candidates = @possible_candidates.length
    new_possible_candidates = @possible_candidates.reject { |v| produce_worse_answer?(v) }
    @possible_candidates = new_possible_candidates
    # possible_candidates = possible_candidates.filter
    show_pruned_stats(old_possible_candidates, new_possible_candidates)
    # Pick the first element in the list and use it as new guess.
    puts 'empty array' if @possible_candidates.empty?
    @possible_candidates[0].join('') unless @possible_candidates.empty?
  end
end
