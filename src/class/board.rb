# frozen_string_literal: true

# load debugger
require 'pry-byebug'

# load modules
require './module/game'
require './module/math_extend'
require './module/board_ui'

# Board generates a mastermind board
class Board
  # mixins (extend for class, include for instance of class)
  include Game
  include MathExtend
  include BoardUi

  # Instance.attribute reader/accessor, Instance.attribute = newVal writing/accessor
  attr_reader :options, :max_turns, :title, :slots, :game_modes
  attr_accessor :board_data, :end_result, :game_board, :code_guess,
                :turn, :code_maker_code, :all_permutations_per_turn, :round_ends, :max_rounds,
                :possible_candidates, :current_key_pegs_count, :total_rounds, :wins, :losses

  # Fill default board data
  @@board_data = {
    title: 'Board game',
    slots: 4,
    options: %w[1 2 3], # options per slot
    max_turns: 12, # turns until draw or loss
    game_modes: %w[1 2 3],
    max_rounds: 1000,
    slot_types: %i[a b] # types = [:code_pegs, :key_pegs]
  }

  # [Board.new] Create default values and draw the initial state
  def initialize
    puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
    # p @all_slots
    # @all_secret_codes = fill_array_4(@code_pegs.length) # possibilities: 6 to the 4 but this is counting repetition
    # for no repetition the formula is: n! / (n-r)! where n are options and r are slots
    # https://www.mathsisfun.com/combinatorics/combinations-permutations.html
    # all possible codebreaker guesses per turn
    fill_default_board_from_board_data
    fill_default_board_with_static_data
    set_default_game_values
    # Create the list 1111,...,6666 of all candidate secret codes
    # @key_pegs = %w[B W]
    # https://stackoverflow.com/questions/4410076/how-can-i-initialize-an-array-inside-a-hash-in-ruby
    # @code_guess = nil
    # @turn = 0
    # @code_maker_code = nil
    # @game_board = enter_board_data
    # p "permutations of #{@slots} slots #{@options.length} options without repetition:
    # #{permutation_without_repetition(@options, @slots)}"
    # p @all_permutations_per_turn.length
    @wins = 0 # as codebreaker
    @losses = 0 # as codebreaker
    @total_rounds = 1
    @round_ends = []
    draw_board(@title)
    puts "R = Red key peg\nW = White key peg\n0 = No key peg\n\n"
  end

  def fill_default_board_with_static_data
    @all_slots = @slots * @max_turns
    @all_permutations_per_turn = @options.permutation(@slots).to_a
  end

  def fill_default_board
    @numbers_to_remove = []
    @numbers_to_include = []
    @possible_code = Array.new(@slots, @options)
    @current_slot = 0
    @turn = 1
    @code_guess = ''
    @code_maker_code = nil
    @possible_candidates = @options.permutation(@slots).to_a
    @current_key_pegs_count = [0, 0]
    @end_result = %w[? ? ? ?]
  end

  def fill_default_board_from_board_data
    @title = @@board_data[:title]
    @slots = @@board_data[:slots]
    @options = @@board_data[:options]
    @slot_types = @@board_data[:slot_types]
    @max_turns = @@board_data[:max_turns]
    @game_modes = @@board_data[:game_modes]
    @max_rounds = @@board_data[:max_rounds]
  end

  # input data into game board according to the slot_types, slots and max_turns
  def enter_board_data(game_board = {})
    @slot_types.each do |type|
      game_board[type] = Array.new(@slots * @max_turns, 0)
    end
    game_board
  end

  def insert_code_guess(code_guess)
    code_guess.chars.each_with_index do |char, k|
      k = k.to_i
      @game_board[:code_pegs][k + @current_slot] = char
      # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    end
  end

  # code_guess = '1234' if code_guess.nil?
  def insert_key_pegs(code_guess)
    # p @code_maker_code
    code_guess.chars.each_with_index do |char, k|
      k = k.to_i
      if @code_maker_code.chars[k] == char
        # p "@code_maker_code.chars[k] #{@code_maker_code.chars[k]} == #{v}"
        @game_board[:key_pegs][k + @current_slot] = 'R'
        # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
      elsif @code_maker_code.chars.include?(char)
        # p "@code_maker_code.chars.find(v) #{v}"
        @game_board[:key_pegs][k + @current_slot] = 'W'
        # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
      end
    end
  end

  def update_board(code_guess = '1234')
    insert_code_guess(code_guess)
    insert_key_pegs(code_guess)
    @current_slot += 4
    draw_board
  end

  def play_rounds(game_mode = 3)
    play_as_code_cracker(game_mode) if game_mode == 1
    play_as_code_maker(game_mode) if game_mode == 2
    cpu_vs_cpu if game_mode == 3
  end

  def reset_game_values
    puts "New Game!\n\n"
    @game_board = { code_pegs: Array.new(4 * @max_turns, 0), key_pegs: Array.new(4 * @max_turns, 0) }
    set_default_game_values
    draw_board
  end

  def set_default_game_values
    fill_default_board
    @game_board = enter_board_data
    # @wins = 0
    # @losses = 0
    # @total_rounds = 0
    # @code_guess = nil
    # @turn = 0
    # @code_maker_code = nil
  end

  def winner?
    @code_guess == @code_maker_code
  end
end
