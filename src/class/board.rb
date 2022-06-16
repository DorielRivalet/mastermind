# load debugger
require 'pry-byebug'

# load modules
require './module/game'
require './module/math_extend'

# Board generates a mastermind board
class Board
  # mixins
  include Game
  include MathExtend

  # Instance.attribute reader/accessor, Instance.attribute = newVal writing/accessor
  attr_reader :options, :max_turns, :title, :slots, :all_turn_combinations, :game_modes
  attr_accessor :board_data, :end_result, :game_board, :code_guess, :turn, :codemaker_code

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
    @title = @@board_data[:title]
    @slots = @@board_data[:slots]
    @options = @@board_data[:options]
    @slot_types = @@board_data[:slot_types]
    @max_turns = @@board_data[:max_turns]
    @game_modes = @@board_data[:game_modes]
    @end_result = @@board_data[:end_result]
    @turn = @@board_data[:turn]
    @code_guess = @@board_data[:code_guess]
    @all_slots = @@board_data[:all_slots]
    @current_slot = @@board_data[:current_slot]
    @codemaker_code = @@board_data[:codemaker_code]
    # p @all_slots
    # @all_secret_codes = fill_array_4(@code_pegs.length) # possibilities: 6 to the 4
    # https://www.mathsisfun.com/combinatorics/combinations-permutations.html
    # all possible codebreaker guesses per turn
    @all_permutations_per_turn = @options.permutation(@slots).to_a
    # @key_pegs = %w[B W]
    # https://stackoverflow.com/questions/4410076/how-can-i-initialize-an-array-inside-a-hash-in-ruby
    # @code_guess = nil
    # @turn = 0
    # @codemaker_code = nil

    @game_board = enter_board_data
    draw_board(@title)
  end

  # input data into game board according to the slot_types, slots and max_turns
  def enter_board_data
    game_board = {}
    @slot_types.each do |type|
      game_board[type] = Array.new(@slots * @max_turns, 0)
    end
    game_board
  end

  # Render the board onto the terminal
  def draw_board(title = nil)
    show_game_title(title) if title
    puts "| #{@end_result[0]} | #{@end_result[1]} | #{@end_result[2]} | #{@end_result[3]}"
    puts '------------------'
    # 44 45 46 47 from codepegs|| 44 45 46 47 fromkeypegs
    # 40 41 42 43 from codepegs|| 40 41 42 43 fromkeypegs
    # 36 37 38 39 from codepegs|| 36 37 38 39 fromkeypegs
    # ...
    # 0 1 2 3 from codepegs || 0 1 2 3 fromkeypegs
    draw_slots(@all_slots)
    draw_options(3) # show 3 options per line
  end

  def draw_slots(all_slots)
    i = all_slots - 1
    row = @max_turns
    while @slots - 1 <= i
      puts "| #{@game_board[:code_pegs][i - 3]} | #{@game_board[:code_pegs][i - 2]} | #{@game_board[:code_pegs][i - 1]} | #{@game_board[:code_pegs][i]} || #{@game_board[:key_pegs][i - 3]}#{@game_board[:key_pegs][i - 2]}#{@game_board[:key_pegs][i - 1]}#{@game_board[:key_pegs][i]} | Row #{row}"
      puts '-------------------------' if @slots - 1 <= i
      i -= @slots
      row -= 1
    end
  end

  # https://stackoverflow.com/questions/48511309/print-array-items-3-per-line
  def draw_options(options_per_line)
    @options.each_slice(options_per_line).with_index do |part, ind|
      puts part.join(', ') + (ind == options_per_line ? '' : ',')
    end
    puts
  end

  def insert_code_guess(code_guess)
    code_guess.split('').each_with_index do |v, k|
      k = k.to_i
      @game_board[:code_pegs][k + @current_slot] = v
      puts "Inserted at row #{@turn} column #{1 + (k % 4)}"
    end
    @current_slot += 4
  end

  def update_board(code_guess)
    insert_code_guess(code_guess)
    draw_board
  end

  def play_rounds(game_mode)
    case game_mode
    when 1
      play_as_codecracker
    when 2
      play_as_codemaker
    when 3
      cpu_vs_cpu
    end
  end

  def reset_game_values
    puts 'New Game!'
    puts
    @end_result = @@board_data[:end_result]
    @game_board = { code_pegs: Array.new(4 * max_turns, 0), key_pegs: Array.new(4 * max_turns, 0)}
    @code_guess = nil
    @turn = @@board_data[:turn]
    @codemaker_code = nil
    @current_slot = @@board_data[:current_slot]
    @codemaker_code = @@board_data[:codemaker_code]
    @game_board = enter_board_data
    draw_board
  end

  def winner?()
    @code_guess == @codemaker_code
  end
end
