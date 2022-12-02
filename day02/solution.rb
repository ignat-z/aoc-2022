input =
  File
    .read("input.txt")
    .split("\n")
strategy = input.map { _1.split(" ") }

# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors
# 1 for Rock, 2 for Paper, and 3 for Scissors

part1 = strategy.map { |l, r|
  if l == "A"
      if r == "Y"
        6 + 2
      elsif r == "X"
        3 + 1
      elsif r == "Z"
        0 + 3
      end
  elsif l == "B"
      if r == "X"
        0 + 1
      elsif r == "Y"
        3 + 2
      else
        6 + 3
      end
  else # l == "C"
      if r == "Z"
        3 + 3
      elsif r == "Y"
        0 + 2
      else
        6 + 1
      end
  end
}.sum

part2 = strategy.map { |l, r|
  if l == "A"
      if r == "Y"
        3 + 1
      elsif r == "X"
        0 + 3
      elsif r == "Z"
        6 + 2
      end
  elsif l == "B"
      if r == "X"
        0 + 1
      elsif r == "Y"
        3 + 2
      else
        6 + 3
      end
  else # l == "C"
      if r == "Z"
        6 + 1
      elsif r == "Y"
        3 + 3
      else
        0 + 2
      end
  end
}.sum

p [part1, part2]
