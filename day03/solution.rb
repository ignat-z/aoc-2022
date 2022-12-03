PRIORITIES = [nil] + ('a'..'z').to_a + ('A'..'Z').to_a

input = File.read("input.txt").split("\n").map(&:chomp)

part1 = input.map { |line|
  left = line.slice(0..(line.length / 2 - 1))
  right = line.slice(line.length / 2..)

  extra = left.chars & right.chars
  raise if extra.length > 1
  extra = extra[0]

  PRIORITIES.index(extra)
}.sum

part2 = input.each_slice(3).map { |elv1, elv2, elv3|
  extra = elv1.chars & elv2.chars & elv3.chars
  raise if extra.length > 1
  extra = extra[0]

  PRIORITIES.index(extra)
}.sum

p [part1, part2]
