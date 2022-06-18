# frozen_string_literal: true

# Generic library for game loops and mechanics
module Game
  # Show game modes and return the selected option
  def select_game_mode_from_array(arr)
    puts "Select game mode\n"
    arr.each_with_index { |v, k| puts "[#{k + 1}]: #{v}" }
    get_option_from_array(Array.new(3) { |i| i + 1 })
  end

  def render_separator(_separator_str, _length)
    separator_str = String.new
  end

  # Get a game mode option from the user
  def get_option_from_array(arr)
    option = nil
    loop do
      option = gets.chomp.to_i
      break if arr.include?(option)

      puts 'Incorrect option'
    end
    option
  end

  # prompt user if they want to restart the game
  def replay_game?
    puts "Restart game? [y/n]\n"
    answer = gets.chomp
    answer.downcase == 'y' || answer.downcase == 'yes'
  end

  # show the winner of the round
  def end_game_msg(code_guess)
    "Correct! The code is #{code_guess}"
  end

  # print game title with ASCII art
  def show_game_title(title)
    puts title
  end
end
