module Game
  def replay_game?
    puts 'Restart game?'
    puts
    answer = gets.chomp
    answer == 'y' || answer.downcase == 'yes'
  end
  def end_game_msg(plr)
    "#{plr} has won!"
  end
  def game_title
    puts "
                              
    | \/| _  _|_ _ _ _ . _  _| 
    |  |(_|_)|_(-| ||||| )(_| 
                             
       "
  end
end