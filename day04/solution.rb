input = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

input = File.read("input.txt")

def overlaps?(main, other)
  main.cover?(other.first) || other.cover?(main.first)
end

assignments =
  input
    .strip
    .split("\n")
    .map { _1.split(",") }
    .map { _1.map { |pair| pair.split("-") } }
    .map { _1.map { |a, b| (a.to_i..b.to_i) } }

part1 = assignments.count { |elf1, elf2| elf1.cover?(elf2) || elf2.cover?(elf1) }
part2 = assignments.count { |elf1, elf2| overlaps?(elf1, elf2) }

p [part1, part2]
