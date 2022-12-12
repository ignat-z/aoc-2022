require 'set'

input = File.read("input.txt")
# input = File.read("sample.txt")

start, finish = nil, nil
area = Array.new(input.split("\n").count) { [] }

input.split("\n").map(&:strip).each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    area[y][x] = case val
    when "S"
      start = [y, x]
      0
    when "E"
      finish = [y, x]
      25
    else
      ('a'..'z').to_a.index(val)
    end
  end
end

def neighbors(x, y, area)
  [[0, 1], [0, -1], [1, 0], [-1, 0]].map { |(dx, dy)|
    [x + dx, y + dy] if (x + dx >= 0 && x + dx < area.first.length) && (y + dy >= 0 && y + dy < area.length)
  }.compact
end

def traverse(area, start, finish)
  visited = Set.new
  queue = [[*start, 0]]
  visited << []
  directions = {}

  while !queue.empty?
    y, x, path = queue.shift
    next if visited.include?([y, x, path])
    heigh = area[y][x]
    visited << [y, x, path]

    neighbors(x, y, area).each do |nx, ny|
      nheigh = area[ny][nx]
      diff = nheigh - heigh

      next if diff > 1
      next if directions[[ny, nx]] && directions[[ny, nx]] < path + 1

      directions[[ny, nx]] = path + 1

      queue << [ny, nx, path + 1]
    end
  end
  directions[finish]
end

part1 = traverse(area, start, finish)

candidates = []
area.each_with_index do |row, y|
  row.each_with_index do |val, x|
    candidates <<[y, x] if val == 0
  end
end
part2 = candidates.map { |nstart|  traverse(area, nstart, finish) }.compact.min

p [part1, part2]
