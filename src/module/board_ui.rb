# frozen_string_literal: true

# load debugger
require 'pry-byebug'

# load modules
require './module/game'
require './module/math_extend'
# require "./class/board"

# Board_ui generates a mastermind board interface
module BoardUi
  # mixins
  extend Game
  extend MathExtend

  # Render the board onto the terminal
  def draw_board
    puts "| #{@end_result[0]} | #{@end_result[1]} | #{@end_result[2]} | #{@end_result[3]}"
    puts '-' * 25
    # 44 45 46 47 from code_pegs|| 44 45 46 47 fromkey_pegs
    # 40 41 42 43 from code_pegs|| 40 41 42 43 fromkey_pegs
    # 36 37 38 39 from code_pegs|| 36 37 38 39 fromkey_pegs
    # ...
    # 0 1 2 3 from code_pegs || 0 1 2 3 fromkey_pegs
    update_slots(@all_slots)
    draw_options(3) # show 3 options per line
  end

  # Define slots boundaries and draw slots
  def update_slots(all_slots)
    i = all_slots - 1
    row = @max_turns
    draw_slots(i, row)
  end

  def display_stats
    # p @round_ends
    puts "Total rounds: #{@total_rounds}\nLosses: #{@losses}\nWins: #{@wins}"
    puts "Winrate: #{percent(@wins, @total_rounds, 4)}%\nAverage turns: #{average_from_array(@round_ends)}\n\n"
  end

  # Render the code and key pegs slots
  def draw_slots(int, row)
    while @slots - 1 <= int
      arr = [@game_board[:code_pegs][int - 3], @game_board[:code_pegs][int - 2], @game_board[:code_pegs][int - 1], @game_board[:code_pegs][int], @game_board[:key_pegs][int - 3],
             @game_board[:key_pegs][int - 2],
             @game_board[:key_pegs][int - 1],
             @game_board[:key_pegs][int]]
      puts "| #{arr[0]} | #{arr[1]} | #{arr[2]} | #{arr[3]} || #{arr[4]}#{arr[5]}#{arr[6]}#{arr[7]} | Row #{row}"
      puts '-' * 25 if @slots - 1 <= int
      int -= @slots
      row -= 1
    end
  end

  # https://stackoverflow.com/questions/48511309/print-array-items-3-per-line
  def draw_options(options_per_line)
    @options.each_slice(options_per_line).with_index do |part, ind|
      print "#{part.join(', ')} #{ind == options_per_line ? '' : ','}\n"
    end
    puts
  end
end
