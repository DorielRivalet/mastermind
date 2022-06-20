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

# load solver algorithms
require './module/swaszek'
require './module/doriel'

# load config
require './config/config'

# Mastermind board game inherits from Board class.
# Board has BoardUi, MathExtend and Game modules included
class Mastermind < Board
  # include Doriel
  include Swaszek
  include Config

  # TODO: add to config file instead
  @@board_data = {
    title: "

    | \/| _  _|_ _ _ _ . _  _|
    |  |(_|_)|_(-| ||||| )(_|

       ",
    slots: 4,
    options: %w[1 2 3 4 5 6],
    max_turns: 12,
    max_rounds: 1000,
    game_modes: ['Code Cracker', 'Code Maker', 'CPU vs CPU'],
    slot_types: %i[code_pegs key_pegs]
  }

  def play_game
    # p @slots
    # p @options.length
    # puts "All possible permutations of valid codes: #{@all_permutations_per_turn.length}"
    # p @all_permutations_per_turn
    loop do
      game_mode = benchmark ? 3 : select_game_mode_from_array(@game_modes)
      play_rounds(game_mode)
      break unless replay_game?(benchmark, @total_rounds, @max_rounds)
      @total_rounds += 1
      @round_ends.push(@turn)
      show_stats
      reset_game_values
    end
    puts "Game ended\n\nFile: #{__FILE__}, Lines of Code (LOC): #{__LINE__}\n"
  end

  def valid_input?(input)
    return false if input.nil?

    input.length == @slots
  end

  def announce_code_maker_win
    @code_maker_code.chars.each_with_index do |char, k|
      @end_result[k] = char
    end
    draw_board
    puts "Code Maker won! The code was #{@code_maker_code}"
    @losses += 1
  end

  def game_end?
    if winner?
      @wins += 1
      puts end_game_msg(@code_guess)
      return true
    end

    if @turn >= @max_turns
      announce_code_maker_win
      return true
    end

    false
  end

  def valid_code?(code)
    return false if code.nil?

    @all_permutations_per_turn.include?(code.chars)
  end

  def increment_turn
    # @code_guess = nil
    @turn += 1
  end

  def check_code(game_mode)
    case game_mode
    when 1 # code_cracker
      until valid_input?(@code_guess)
        @code_guess = gets.chomp.to_s
        # puts 'Wrong input' unless valid_input?(@code_guess)
      end
    when 2 # code_maker
      until valid_code?(@code_maker_code)
        @code_maker_code = gets.chomp.to_s
        # puts 'Invalid code' unless valid_code?(@code_maker_code)
      end
    end
  end

  # loop automatic guesses
  def loop_guesses
    loop do
      # puts "Inserting a code ... [#{@slots} slots, #{@options.length} colors]"
      # @code_guess = @all_permutations_per_turn.sample.join('')
      @code_guess = swaszek
      puts "Inserted #{@code_guess}\n\n"
      update_board(@code_guess)
      break if game_end?

      increment_turn
    end
  end

  def play_as_code_cracker(game_mode)
    @code_maker_code = @all_permutations_per_turn.sample.join('')
    loop do
      @code_guess = nil
      puts "Insert a code [#{@slots} slots, #{@options.length} colors]"
      check_code(game_mode)
      update_board(@code_guess)
      # attach debugger
      # binding.pry
      break if game_end?

      increment_turn
    end
  end

  def play_as_code_maker(game_mode)
    puts "Make a code [#{@slots} slots, #{@options.length} colors]"
    check_code(game_mode)
    loop_guesses
  end

  def cpu_vs_cpu
    # puts "Making a code ... [#{@slots} slots, #{@options.length} colors]"
    @code_maker_code = @all_permutations_per_turn.sample.join('')
    puts "Made code #{@code_maker_code}"
    loop_guesses
  end
end
