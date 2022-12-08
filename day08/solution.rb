input = File.read("input.txt")

heights = input
  .split("\n")
  .map(&:strip)
  .map(&:chars)
  .map { _1.map(&:to_i) }

total = 0
heights.each_with_index do |row, y|
  row.each_with_index do |val, x|
    next if y == 0 || x == 0 || x == row.length - 1 || y == heights.length - 1
    visible =
        row.slice(0..x - 1).all? { _1 < val } ||
        row.slice(x + 1..).all? { _1 < val } ||
        heights.map { _1[x] }.slice(0..y - 1).all? { _1 < val } ||
        heights.map { _1[x] }.slice(y + 1..).all? { _1 < val }
    total +=1 if visible
  end
end

part1 = total + (heights.size * 4 - 4)

max = 0
heights.each_with_index do |row, y|
  row.each_with_index do |val, x|
    next if y == 0 || x == 0 || x == row.length - 1 || y == heights.length - 1

    left = row.slice(0..x - 1).reverse.take_while { _1 < val }.count
    left += 1 if left == 0 || left < x

    right = row.slice(x + 1..).take_while { _1 < val }.count
    right += 1 if right == 0 || x + right < row.length - 1

    up = heights.map { _1[x] }.slice(0..y - 1).reverse.take_while { _1 < val }.count
    up += 1 if up == 0 || up < y

    down = heights.map { _1[x] }.slice(y + 1..).take_while { _1 < val }.count
    down += 1 if down == 0 || y + down < heights.length - 1

    score  = left * right * up * down
    max = [score, max].max
  end
end

part2 = max

p [part1, part2]
