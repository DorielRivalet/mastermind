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

# Mastermind board game inherits from Board class.
# Board has BoardUi, MathExtend and Game modules included
class Mastermind < Board

  include Swaszek

  # TODO: add to config file instead
  @@board_data = {
    title: "
    ▄▄
    ▀████▄     ▄███▀                ██                                     ██                  ▀███  
      ████    ████                  ██                                                           ██  
      █ ██   ▄█ ██  ▄█▀██▄  ▄██▀████████  ▄▄█▀██▀███▄███▀████████▄█████▄ ▀███ ▀████████▄    ▄█▀▀███  
      █  ██  █▀ ██ ██   ██  ██   ▀▀ ██   ▄█▀   ██ ██▀ ▀▀  ██    ██    ██   ██   ██    ██  ▄██    ██  
      █  ██▄█▀  ██  ▄█████  ▀█████▄ ██   ██▀▀▀▀▀▀ ██      ██    ██    ██   ██   ██    ██  ███    ██  
      █  ▀██▀   ██ ██   ██  █▄   ██ ██   ██▄    ▄ ██      ██    ██    ██   ██   ██    ██  ▀██    ██  
    ▄███▄ ▀▀  ▄████▄████▀██▄██████▀ ▀████ ▀█████▀████▄  ▄████  ████  ████▄████▄████  ████▄ ▀████▀███▄
    ",
    slots: 4,
    options: %w[1 2 3 4 5 6],
    max_turns: 12,
    max_rounds: 2_000, # for benchmarking
    game_modes: ['Code Cracker', 'Code Maker', 'CPU vs CPU', 'Benchmark'],
    slot_types: %i[code_pegs key_pegs]
  }

  def play_game
    benchmark = false
    loop do
      game_mode = benchmark ? 3 : select_game_mode_from_array(@game_modes)
      benchmark = true if game_mode == 4
      play_rounds(game_mode)
      @round_ends.push(@turn)
      display_stats
      break unless replay_game?(benchmark, @total_rounds, @max_rounds)

      @total_rounds += 1
      reset_game_values
    end
  end

  def valid_input?(input)
    input.nil? ? false : input.length == @slots
  end

  def set_end_result
    @code_maker_code.chars.each_with_index do |char, k|
      @end_result[k] = char
    end
    draw_board
  end

  def game_end?(game_mode)
    if guessed_code_correct? || @turn >= @max_turns
      set_end_result
      puts end_game_msg(@code_guess) if guessed_code_correct?
      puts "Code Maker won! The code was #{@code_maker_code}" if @turn >= @max_turns && !guessed_code_correct?
      return add_points(game_mode, guessed_code_correct?, @turn >= @max_turns)
    end

    false
  end

  def add_points(game_mode, condition1, condition2)
    if [1, 3].include?(game_mode)
      condition1 ? @wins += 1 : @losses += 1
    end

    if game_mode == 2
      condition2 ? @wins += 1 : @losses += 1
    end
    'Points added!' # truthy
  end

  def valid_code?(code)
    code.nil? ? false : @all_permutations_per_turn.include?(code.chars)
  end

  def check_code(game_mode)
    case game_mode
    when 1
      until valid_input?(@code_guess)
        @code_guess = gets.chomp.to_s
        puts "Wrong input, code has to be #{@slots} digits" unless valid_input?(@code_guess)
      end
    when 2
      until valid_code?(@code_maker_code)
        @code_maker_code = gets.chomp.to_s
        puts "Invalid code, code has to be #{@slots} digits" unless valid_code?(@code_maker_code)
      end
    end
  end

  # loop automatic guesses
  def loop_guesses(game_mode)
    loop do
      # puts "Inserting a code ... [#{@slots} slots, #{@options.length} colors]"
      # @code_guess = @all_permutations_per_turn.sample.join('')
      @code_guess = swaszek
      # puts "Inserted #{@code_guess}\n\n"
      update_board(@code_guess)
      break if game_end?(game_mode)

      @turn += 1
    end
  end

  def play_as_code_cracker(game_mode)
    @code_maker_code = @all_permutations_per_turn.sample.join('')
    loop do
      @code_guess = nil
      puts "Insert a code [#{@slots} slots, #{@options.length} colors]"
      check_code(game_mode)
      update_board(@code_guess)
      break if game_end?(game_mode)

      @turn += 1
    end
  end

  def play_as_code_maker(game_mode)
    puts "Make a code [#{@slots} slots, #{@options.length} colors]"
    check_code(game_mode)
    loop_guesses(game_mode)
  end

  def cpu_vs_cpu(game_mode)
    # puts "Making a code ... [#{@slots} slots, #{@options.length} colors]"
    @code_maker_code = @all_permutations_per_turn.sample.join('')
    # puts "Made code #{@code_maker_code}"
    loop_guesses(game_mode)
  end
end
