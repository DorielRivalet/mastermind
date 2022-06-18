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
  attr_accessor :board_data, :end_result, :game_board, :code_guess, :turn, :codemaker_code, :all_permutations_per_turn

  # Fill default board data
  @@board_data = {
    title: 'Board game',
    slots: 4,
    options: %w[1 2 3], # options per slot
    max_turns: 12, # turns until draw or loss
    game_modes: %w[1 2 3],
    slot_types: %i[a b], # types = [:code_pegs, :key_pegs]
    end_result: %w[? ? ? ?],
    turn: 1,
    code_guess: '123456',
    all_slots: 12 * 4, # slots times max turns
    current_slot: 0,
    codemaker_code: nil
  }

  # [Board.new] Create default values and draw the initial state
  def initialize
    puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
    # p @all_slots
    # @all_secret_codes = fill_array_4(@code_pegs.length) # possibilities: 6 to the 4
    # https://www.mathsisfun.com/combinatorics/combinations-permutations.html
    # all possible codebreaker guesses per turn
    fill_default_board
    @code_guess = @@board_data[:code_guess]
    @codemaker_code = @@board_data[:codemaker_code]
    @all_permutations_per_turn = @options.permutation(@slots).to_a
    # @key_pegs = %w[B W]
    # https://stackoverflow.com/questions/4410076/how-can-i-initialize-an-array-inside-a-hash-in-ruby
    # @code_guess = nil
    # @turn = 0
    # @codemaker_code = nil
    @game_board = enter_board_data
    draw_board(@title)
  end

  def fill_default_board
    @title = @@board_data[:title]
    @slots = @@board_data[:slots]
    @options = @@board_data[:options]
    @slot_types = @@board_data[:slot_types]
    @max_turns = @@board_data[:max_turns]
    @game_modes = @@board_data[:game_modes]
    @end_result = @@board_data[:end_result]
    @turn = @@board_data[:turn]
    @all_slots = @@board_data[:all_slots]
    @current_slot = @@board_data[:current_slot]
  end

  # input data into game board according to the slot_types, slots and max_turns
  def enter_board_data
    game_board = {}
    @slot_types.each do |type|
      game_board[type] = Array.new(@slots * @max_turns, 0)
    end
    game_board
  end

  def insert_code_guess(code_guess)
    code_guess.chars.each_with_index do |v, k|
      k = k.to_i
      @game_board[:code_pegs][k + @current_slot] = v
      # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    end
  end

  def insert_keypegs(code_guess)
    # p @codemaker_code
    code_guess.chars.each_with_index do |v, k|
      k = k.to_i
      if @codemaker_code.chars[k] == v
        # p "@codemaker_code.chars[k] #{@codemaker_code.chars[k]} == #{v}"
        @game_board[:key_pegs][k + @current_slot] = 'B'
        # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
      elsif @codemaker_code.chars.include?(v)
        # p "@codemaker_code.chars.find(v) #{v}"
        @game_board[:key_pegs][k + @current_slot] = 'W'
        # puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
      end
    end
  end

  def update_board(code_guess)
    insert_code_guess(code_guess)
    insert_keypegs(code_guess)
    @current_slot += 4
    draw_board
  end

  def play_rounds(game_mode)
    play_as_codecracker(game_mode) if game_mode == 1
    play_as_codemaker(game_mode) if game_mode == 2
    cpu_vs_cpu if game_mode == 3
  end

  def reset_game_values
    puts "New Game!\n"
    @end_result = %w[? ? ? ?]
    @game_board = { code_pegs: Array.new(4 * max_turns, 0), key_pegs: Array.new(4 * max_turns, 0) }
    @code_guess = nil
    @turn = @@board_data[:turn]
    @codemaker_code = nil
    @current_slot = @@board_data[:current_slot]
    @codemaker_code = @@board_data[:codemaker_code]
    @game_board = enter_board_data
    draw_board
  end

  def winner?
    @code_guess == @codemaker_code
  end
end
