# load debugger
require 'pry-byebug'

# Wanted output
# current_Array = Array.new(slots) {|i| (i+1).to_s} #=>
# currentboard[1] = 1111, String.new(slots) {|i| i.to_s}
# currentboard[2] = 1112,
# currentboard[3] = 1113,
# currentboard[4] = 1114,
# currentboard[5] = 1115,
# currentboard[6] = 1116,
# currentboard[7] = 1121,
# currentboard[8] = 1112,
# currentboard[1296] = 6666

# Extend math library
module MathExtend
  # Fill an array with 4 digits and 6 possible values each (senary number system)
  def fill_array_4(possibilities)
    current_board = []
    puts 'Filling board...'
    for i in 1..possibilities do
      for j in 1..possibilities do
        for k in 1..possibilities do
          for l in 1..possibilities do
            current_board << "#{i}#{j}#{k}#{l}"
            # puts "#{i}#{j}#{k}#{l}"
          end
        end
      end
    end
    puts 'Total possible choices: ' + current_board.length.to_s + '!'
    puts
    current_board
  end

  def populate_array(slots, possibilities)
    current_board = []
    slots = Array.new(slots) { |i| (i + 1).to_s }
    possibilities = Array.new(possibilities) { |i| (i + 1).to_s }
    permutations = possibilities.length**slots.length

    # for i in 0..permutations-1
    # current_board[i] = # from_deci("",possibilities.length,i)
    # end

    p current_board.first, current_board.last
    current_board
  end
  # https://www.geeksforgeeks.org/convert-base-decimal-vice-versa/
  # Python3 Program to convert decimal to
  # any given base

  # To return char for a value. For example
  # '2' is returned for 2. 'A' is returned
  # for 10. 'B' for 11

  # def reVal(num):
  #   if (num >= 0 and num <= 9):
  #     return chr(num + ord('0'));
  #   else:
  #     return chr(num - 10 + ord('A'));

  def re_val(num)
    if num >= 0 && num <= 9
      (num + '0'.ord).chr
    else
      (num - 10 + 'A'.ord).chr
    end
  end

  # Utility function to reverse a string
  # def strev(str):

  #   len = len(str);
  #   for i in range(int(len / 2)):
  #     temp = str[i];
  #     str[i] = str[len - i - 1];
  #     str[len - i - 1] = temp;

  def strev(str)
    len = str.length
    for i in 0..len / 2
      temp = str[i]
      str[i] = str[len - i - 1]
      str[len - i - 1] = temp
    end
  end

  # Function to convert a given decimal
  # number to a base 'base' and
  # def fromDeci(res, base, inputNum):
  #   index = 0; # Initialize index of result
  #   # Convert input number is given base
  #   # by repeatedly dividing it by base
  #   # and taking remainder
  #   while (inputNum > 0):
  #       res+= reVal(inputNum % base);
  #       inputNum = int(inputNum / base);
  #   # Reverse the result
  #   res = res[::-1];
  #   return res;

  def from_deci(res, base, input_num)
    while input_num.positive?
      res += re_val(input_num % base)
      input_num = (input_num / base).to_i
    end
    res.reverse
  end
end
