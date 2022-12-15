input = File.read("sample.txt"); y = 10
input = File.read("input.txt"); y = 2000000

require 'set'
occupied = Set.new

positions = input
  .split("\n")
  .map { sensor, beacon = _1.split(": ") }
  .map { |sensor, beacon|
    [
      [sensor.match(/x=(-?\d+)/)[1].to_i, sensor.match(/y=(-?\d+)/)[1].to_i],
      [beacon.match(/x=(-?\d+)/)[1].to_i, beacon.match(/y=(-?\d+)/)[1].to_i]
    ]
  }

def manhattan(p1, p2)
  x1, y1 = p1
  x2, y2 = p2
  (x1 - x2).abs + (y1 - y2).abs
end

positions.each do |(sensor, beacon)|
  max_distance = manhattan(sensor, beacon)
  x1, y1 = sensor
  y2 = y

  (0..max_distance).each do |distance|
    f1 = -distance + (y1 - y2).abs + x1
    f2 = distance - (y1 - y2).abs + x1

    occupied << f1 if distance == manhattan(sensor, [f1, y2])
    occupied << f2 if distance == manhattan(sensor, [f2, y2])
  end
end

beacons = positions.map(&:last)
part1 = occupied.reject { |x| beacons.include?([x, y]) }.count



stop = false
current = nil
# min_y, max_y = 0, 20
min_y, max_y = 0, 4000000


def check(positions, x, y)
    positions.all? { |(sensor, beacon)|
      next false if beacon == [x, y]

      max_distance = manhattan(sensor, beacon)
      current_distance = manhattan(sensor, [x, y])
      current_distance > max_distance
    }
end

(min_y..max_y).each do |y|
  p y if y % 100_000 == 0
  occupied = []

  break if stop

  positions.each do |(sensor, beacon)|
    distance = manhattan(sensor, beacon)
    x1, y1 = sensor
    y2 = y

    f1 = -distance + (y1 - y2).abs + x1
    f2 = distance - (y1 - y2).abs + x1

    if distance == manhattan(sensor, [f2, y2]) && distance == manhattan(sensor, [f1, y2])
      occupied << Range.new(*[f1, f2].sort)
    end
  end

  occupied.map! { |range| range.first < 0 ? (0..range.last) : range }
  occupied.uniq!
  occupied.sort_by!(&:first)

  x = 0
  loop do
    break if stop || x >= max_y
    current = [x, y]
    stop = check(positions, x, y)
    x += 1

    in_range = occupied.find { _1.member?(x) }
    x = in_range ? in_range.last + 1 : x
  end
end

part2 = current[0] * 4000000 + current[1]

p [part1, part2]
