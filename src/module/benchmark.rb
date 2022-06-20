# frozen_string_literal: true

# load debugger
require 'pry-byebug'

# load classes
require './class/mastermind'
require './module/math_extend'

# Benchmark solver algorithms
module Benchmark
  # # prune keys according to key_pegs
  # def benchmark(function, max_tries)
  #   losses = 0.0
  #   wins = 0.0
  #   1..max_tries do
  #     losses += 1 if function == "Code maker won"
  #     wins += 1 if function == "Code breaker won"
  #   end
  #   percentage_won = percent(losses, wins, 4)
  #   puts "total tries: #{max_tries}, losses: #{losses}, wins: #{wins}, percentage won: #{percentage_won}"
  # end
end
