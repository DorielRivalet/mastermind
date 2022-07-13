# frozen_string_literal: true

# load debugger
require 'pry-byebug'

# Wanted output
# current_Array = Array.new(slots) {|i| (i+1).to_s} #=>
# current_board[1] = 1111, String.new(slots) {|i| i.to_s}
# current_board[2] = 1112,
# current_board[3] = 1113,
# current_board[4] = 1114,
# current_board[5] = 1115,
# current_board[6] = 1116,
# current_board[7] = 1121,
# current_board[8] = 1112,
# current_board[1296] = 6666

# Extend math library
module MathExtend
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
  # def stringReverse(str):

  #   len = len(str);
  #   for i in range(int(len / 2)):
  #     temp = str[i];
  #     str[i] = str[len - i - 1];
  #     str[len - i - 1] = temp;

  def string_reverse(str)
    len = str.length
    (0..len / 2).each do |i|
      temp = str[i]
      str[i] = str[len - i - 1]
      str[len - i - 1] = temp
    end
  end

  # Function to convert a given decimal
  # number to a base 'base' and
  # def fromDecimal(res, base, inputNum):
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

  # Factorial written by Doriel Rivalet
  def factorial(number)
    # return 1 if number.zero?
    # return nil if  number < 1
    return 1 if number <= 1
    return number if number == 1

    number * factorial(number - 1)
  end

  def percent(number, total, rounding)
    number = number.to_f
    total = total.to_f
    (number / total * 100.0).round(rounding)
  end

  def permutation_without_repetition(options, slots)
    options = options.length if options.instance_of?(Array) || options.instance_of?(Hash)
    factorial(options) / factorial(options - slots)
  end

  def average_from_array(arr)
    (arr.reduce { |accumulator, round_end| accumulator + round_end }.to_f / arr.size).round(4)
  end

  def from_decimal(res, base, input_num)
    while input_num.positive?
      res += re_val(input_num % base)
      input_num = (input_num / base).to_i
    end
    res.reverse
  end
end
