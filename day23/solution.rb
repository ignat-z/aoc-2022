# input = File.read("sample1.txt")
# input = File.read("sample.txt")
input = File.read("input.txt")

elves = []

input.split("\n").map(&:chomp).map(&:chars).each_with_index do |row, y|
  row.each_with_index do |val, x|
    elves << [x, y] if val == "#"
  end
end

def count_empty(elves)
  xs = elves.map(&:first).minmax
  ys = elves.map(&:last).minmax
  (xs[1] - xs[0] + 1) * (ys[1] - ys[0] + 1) - elves.count
end

def print_map(elves)
  xs = elves.map(&:first).minmax
  xs = [xs[0] - 2, xs[1] + 2]
  ys = elves.map(&:last).minmax
  ys = [ys[0] - 2, ys[1] + 2]
  Range.new(*ys).each do |y|
    Range.new(*xs).each do |x|
      print elves.include?([x, y]) ? "#" : "."
    end
    puts
  end
end

def can_move?(x, y, elves)
  [-1, 0, 1].each { |dx|
    [-1, 0, 1].each { |dy|
      next if dx == 0 && dy == 0
      return true if elves.include?([x + dx, y + dy])
    }
  }
  false
end

SHIFTS = [
  [1, [[0, -1], [+1, -1], [-1, -1]]],
  [2, [[0, +1], [+1, +1], [-1, +1]]],
  [3, [[-1, 0], [-1, -1], [-1, +1]]],
  [4, [[+1, 0], [+1, -1], [+1, +1]]]
]

# require 'set'

# 10.times do |round|
#   elves = Set.new(elves)
#   plans = {}
#   elves.each_with_index do |elf, idx|
#     x, y = elf

#     if count_around(x, y, elves) == 0
#       plans[elf] = 0
#       next
#     end

#     can_go_to = SHIFTS.map { |(dir, values)|
#       [dir, values.map { |(dx, dy)| [x + dx, y + dy] }.none? { elves.include?(_1) }]
#     }.select { |(dir, val)| val }.map(&:first)

#     plans[elf] = can_go_to.first || 0
#   end

#   next_elves = plans.map do |elf, dir|
#     x, y = elf
#     case dir
#     in 0 then [x, y]
#     in 1 then [x, y - 1]
#     in 2 then [x, y + 1]
#     in 3 then [x - 1, y]
#     in 4 then [x + 1, y]
#     end
#   end

#   elves = elves.map.with_index do |current, idx|
#     new_pos = next_elves[idx]
#     count = next_elves.count { _1 == new_pos }

#     if count == 1
#       new_pos
#     else
#       current
#     end
#   end

#   SHIFTS.rotate!(1)
# end

# part1 = count_empty(elves)

require "set"
round = 0
loop do
  round += 1

  elves = Set.new(elves)
  plans = {}
  elves.each_with_index do |elf, idx|
    x, y = elf

    if !can_move?(x, y, elves)
      plans[elf] = 0
      next
    end

    plans[elf] = (SHIFTS.find { |(dir, values)|
      values.map { |(dx, dy)| [x + dx, y + dy] }.none? { elves.include?(_1) }
    } || [0]).first
  end

  break(round) if plans.values.all?(&:zero?)

  next_elves = plans.map do |elf, dir|
    x, y = elf
    case dir
    in 0 then [x, y]
    in 1 then [x, y - 1]
    in 2 then [x, y + 1]
    in 3 then [x - 1, y]
    in 4 then [x + 1, y]
    end
  end

  uniqness = {}
  next_elves.each {
    uniqness[_1] ||= 0
    uniqness[_1] += 1
  }

  elves = elves.map.with_index do |current, idx|
    new_pos = next_elves[idx]

    if uniqness[new_pos] == 1
      new_pos
    else
      current
    end
  end

  SHIFTS.rotate!(1)
end

p round
