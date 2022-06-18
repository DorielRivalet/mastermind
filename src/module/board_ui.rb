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
  def draw_board(title = nil)
    show_game_title(title) if title
    puts "| #{@end_result[0]} | #{@end_result[1]} | #{@end_result[2]} | #{@end_result[3]}\n------------------"
    # 44 45 46 47 from codepegs|| 44 45 46 47 fromkeypegs
    # 40 41 42 43 from codepegs|| 40 41 42 43 fromkeypegs
    # 36 37 38 39 from codepegs|| 36 37 38 39 fromkeypegs
    # ...
    # 0 1 2 3 from codepegs || 0 1 2 3 fromkeypegs
    update_slots(@all_slots)
    draw_options(3) # show 3 options per line
  end

  def update_slots(all_slots)
    i = all_slots - 1
    row = @max_turns
    draw_slots(i, row)
  end

  def draw_slots(i, row)
    while @slots - 1 <= i
      arr = [@game_board[:code_pegs][i - 3], @game_board[:code_pegs][i - 2], @game_board[:code_pegs][i - 1], @game_board[:code_pegs][i], @game_board[:key_pegs][i - 3],
             @game_board[:key_pegs][i - 2],
             @game_board[:key_pegs][i - 1],
             @game_board[:key_pegs][i]]
      puts "| #{arr[0]} | #{arr[1]} | #{arr[2]} | #{arr[3]} || #{arr[4]}#{arr[5]}#{arr[6]}#{arr[7]} | Row #{row}"
      puts '-------------------------' if @slots - 1 <= i
      i -= @slots
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
