# frozen_string_literal: true

# Specifications
# Build a Mastermind game from the command line where you have 12 turns to guess the secret code,
# starting with you guessing the computer’s random code.
# Think about how you would set this problem up!
# Build the game assuming the computer randomly selects the secret colors and the human player must guess them.
# Remember that you need to give the proper feedback on how good the guess was each turn!
# Now refactor your code to allow the human player to choose
# whether they want to be the creator of the secret code or the guesser.
# Build it out so that the computer will guess  you decide to choose your own secret colors.
# You may choose to implement a computer strategy that follows the rules of the game or you can modify these rules.
# If you choose to modify the rules, you can provide the computer additional information about each guess.
# For example, you can start by having the computer guess randomly, but keep the ones that match exactly.
# You can add a little bit more intelligence to the computer player so that,
# the computer has guessed the right color but the wrong position,
# its next guess will need to include that color somewhere.
# If you want to follow the rules of the game,
# you’ll need to research strategies for solving Mastermind, such as this post.

# load superclass
require './class/board'

# load swaszek algorithm
require './module/swaszek'

# Mastermind board game inherits from Board class.
# Board has MathExtend and Game modules included
class Mastermind < Board
  include Swaszek
  @@board_data = {
    title: "

    | \/| _  _|_ _ _ _ . _  _|
    |  |(_|_)|_(-| ||||| )(_|

       ",
    slots: 4,
    options: %w[1 2 3 4 5 6],
    max_turns: 12,
    game_modes: ['Codecracker', 'Codemaker', 'CPU vs CPU'],
    slot_types: %i[code_pegs key_pegs],
    end_result: %w[? ? ? ?],
    turn: 1,
    code_guess: '',
    all_slots: 12 * 4,
    current_slot: 0
  }

  def play_game
    loop do
      game_mode = select_game_mode_from_array(@game_modes)
      play_rounds(game_mode)
      break unless replay_game?

      reset_game_values
    end
    puts 'Game ended'
    puts "File: #{__FILE__}, Lines of Code (LOC): #{__LINE__}"
  end

  def valid_input?(input)
    return false if input.nil?

    input.length == @slots
  end

  def annnounce_codemaker_win
    @codemaker_code.chars.each_with_index do |v, k|
      @end_result[k] = v
    end
    draw_board
    puts "Codemaker won! The code was #{@codemaker_code}"
  end

  def game_end?
    if @turn >= @max_turns
      annnounce_codemaker_win
      return true
    end

    if winner?
      puts end_game_msg(@code_guess)
      return true
    end

    false
  end

  def valid_code?(code)
    return false if code.nil?

    @all_permutations_per_turn.include?(code.chars)
  end

  def increment_turn
    @code_guess = nil
    @turn += 1
  end

  def check_code(game_mode)
    case game_mode
    when 1 # Codecracker
      until valid_input?(@code_guess)
        @code_guess = gets.chomp.to_s
        # puts 'Wrong input' unless valid_input?(@code_guess)
      end
    when 2 # Codemaker
      until valid_code?(@codemaker_code)
        @codemaker_code = gets.chomp.to_s
        # puts 'Invalid code' unless valid_code?(@codemaker_code)
      end
    end
  end

  # loop automatic guesses
  def loop_guesses
    candidates = @all_permutations_per_turn
    loop do
      # puts "Inserting a code ... [#{@slots} slots, #{@options.length} colors]"
      # @code_guess = @all_permutations_per_turn.sample.join('')
      swaszek(@game_board[:key_pegs], candidates)
      update_board(@code_guess)
      break if game_end?

      increment_turn
    end
  end

  def play_as_codecracker(game_mode)
    @codemaker_code = @all_permutations_per_turn.sample.join('')
    loop do
      puts "Insert a code [#{@slots} slots, #{@options.length} colors]"
      check_code(game_mode)
      update_board(@code_guess)
      # attach debugger
      # binding.pry
      break if game_end?

      increment_turn
    end
  end

  def play_as_codemaker(game_mode)
    puts "Make a code [#{@slots} slots, #{@options.length} colors]"
    check_code(game_mode)
    loop_guesses
  end

  def cpu_vs_cpu
    # puts "Making a code ... [#{@slots} slots, #{@options.length} colors]"
    @codemaker_code = @all_permutations_per_turn.sample.join('')
    loop_guesses
  end
end
