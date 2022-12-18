# input = File.read("sample.txt").strip
input = File.read("input.txt").strip
# input =  "1,1,1\n2,1,1"

require 'set'
coordinates = input.split("\n").map { _1.split(",").map(&:to_i) }.to_set

def neighbours(point)
  [
  [0, 0, 1],
  [0, 0, -1],
  [-1, 0, 0],
  [1, 0, 0],
  [0, 1, 0],
  [0, -1, 0],
].map { |adj| point.zip(adj).map(&:sum) }
end

part1 = coordinates.map { |point| neighbours(point).select { |candidate| !coordinates.include?(candidate) } }.map { _1.count }.sum

def outside?(candidate, coordinates)
  minx, maxx = coordinates.map { _1[0] }.minmax
  miny, maxy = coordinates.map { _1[1] }.minmax
  minz, maxz = coordinates.map { _1[2] }.minmax

  visited = Set.new
  q = [candidate]
  while !q.empty? do
    x, y, z = q.pop
    next if visited.include?([x, y, z])
    visited << [x, y, z]

    return true if !(minx..maxx).include?(x)
    return true if !(miny..maxy).include?(y)
    return true if !(minz..maxz).include?(z)

    neighbours([x, y, z]).select { |candidate| !coordinates.include?(candidate) }.each { q << _1 }
  end

  return false
end


candidates = coordinates.map { |point| neighbours(point).select { |candidate| !coordinates.include?(candidate) } }.flatten(1)
part2 = candidates.count { outside?(_1, coordinates) }

p [part1, part2]
