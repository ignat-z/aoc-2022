input = File.read("input.txt")

part1 = input.chars.each_cons(4).each_with_index.find { |group, idx|
  group.uniq.length == 4
}.last + 4

part2 = input.chars.each_cons(14).each_with_index.find { |group, idx|
  group.uniq.length == 14
}.last + 14

p [part1, part2]
