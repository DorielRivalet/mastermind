# frozen_string_literal: true

# Generic library for game loops and mechanics
module Game
  # Show game modes and return the selected option
  def select_game_mode_from_array(arr)
    puts "Select game mode\n"
    arr.each_with_index { |game_mode, k| puts "[#{k + 1}]: #{game_mode}" }
    option = get_option_from_array(Array.new(arr.length) { |i| i + 1 })
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
    puts "Restart game? [y/N]\n"
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
    puts "#{title}\n"
    puts "Designer: Mordecai Meirowitz"
    puts "Years active: 1970 to present"
    puts "Genres: Board game, Paper & pencil game [root]"
    puts "Players: 2"
    puts "Setup time: < 5 minutes"
    puts "Playing time: 10–30 minutes"
    puts "Random chance: Negligible"
    puts "Age range: 8 and up"
    puts "Description: Solve your opponent's code in fewer turns than it takes your opponent to solve your code.\n\n"
  end
end
