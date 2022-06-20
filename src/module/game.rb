# frozen_string_literal: true

# Generic library for game loops and mechanics
module Game
  # Show game modes and return the selected option
  def select_game_mode_from_array(arr)
    puts "Select game mode\n"
    arr.each_with_index { |game_mode, k| puts "[#{k + 1}]: #{game_mode}" }
    option = get_option_from_array(Array.new(3) { |i| i + 1 })
    puts "Selected #{arr[option - 1]}\n\n"
    option
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
  def replay_game?(benchmark, tries, max_tries)
    puts "Restart game? [y/n]\n"
    # p benchmark, tries, max_tries
    if benchmark
      return false if tries == max_tries

      return true
    end

    answer = gets.chomp
    answer.downcase == 'y' || answer.downcase == 'yes'
  end

  # show the winner of the round
  def end_game_msg(code_guess)
    "Correct! The code is #{code_guess}\n\n"
  end

  # print game title with ASCII art
  def show_game_title(title)
    puts title
  end
end
