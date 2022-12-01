input =
  File
    .read("input.txt")
    .split("\n\n")

part1 = input.map { _1.split("\n").map(&:to_i).sum }.sort.last
part2 = input.map { _1.split("\n").map(&:to_i).sum }.sort.last(3).sum

p [part1, part2]
