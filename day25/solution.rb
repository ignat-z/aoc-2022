DIGITS = {
  '=' => -2,
  '-' => -1,
  '0' => 0,
  '1' => 1,
  '2' => 2
}

SNDIGITS = {
  0 => '0',
  1 => '1',
  2 => '2',
  -1 => '-',
  -2 => '='
}

def from_snafu(number)
  number.reverse.chars.map.with_index { |num, power|
    5 ** power * DIGITS.fetch(num)
  }.sum
end

def to_snafu(number)
  digits = []
  loop do
    break if number == 0
    number, rem = number.divmod(5)
    if rem <= 2
      digits << SNDIGITS.fetch(rem)
    else
      number +=1
      digits << SNDIGITS.fetch(rem - 5)
    end
  end
  digits.reverse.join
end

input = File.read("input.txt")
total = input.split("\n").map(&:strip).map { from_snafu(_1) }.sum
p to_snafu(total)
