input = File.read("input.txt")

VALVES = []
FLOWS  = []
LEADS  = []

input
  .strip
  .split("\n")
  .map(&:strip)
  .each {
    VALVES << _1.match(/Valve (.+) has/)[1]
    FLOWS  << _1.match(/rate=(\d+);/)[1].to_i
    LEADS  << _1.match(/to valves? (.+)/)[1].split(", ")
  }

LEADS.map! { _1.map { |val| VALVES.index(val) } }

DISTANCES = Array.new(VALVES.length) { Array.new(VALVES.length, Float::INFINITY) }
LEADS.each_with_index do |to_mark, from|
  to_mark.each { |to|
    DISTANCES[from][to] = 1
    DISTANCES[to][from] = 1
  }
end

DISTANCES.each_with_index do |_, k|
  DISTANCES.each_with_index do |_, i|
    DISTANCES.each_with_index do |_, j|
      DISTANCES[i][j] = [
        DISTANCES[i][j],
        DISTANCES[i][k] + DISTANCES[k][j]
      ].min
    end
  end
end

MEM = {}
def max_current(current, closed, tick)
  state = [current, closed, tick]
  return MEM[state] if MEM[state]

  MEM[state] = [
    (FLOWS[current] * (tick - 1) + max_current(current, closed - [current], tick - 1) if closed.include?(current) && tick > 0),
    *closed.map { |candidate|
      next if candidate == current
      next if DISTANCES[current][candidate] > tick

      max_current(candidate, closed, tick - DISTANCES[current][candidate])
    }
  ].compact.max || 0
end

candidates = FLOWS.map.with_index { |val, idx| idx if val != 0 }.compact
part1 = max_current(VALVES.index("AA"), candidates, 30)

MEM2 = {}
def two_max_current(current, closed, tick)
  state = [current, closed, tick]
  return MEM2[state] if MEM2[state]

  MEM2[state] = [
    ((FLOWS[current] * (tick - 1)) + two_max_current(current, closed - [current], tick - 1) if closed.include?(current) && tick > 0),
    *closed.map { |candidate|
      next if candidate == current
      next if DISTANCES[current][candidate] > tick

      two_max_current(candidate, closed, tick - DISTANCES[current][candidate])
    }
  ].compact.max || max_current(VALVES.index("AA"), closed, 26)
end

candidates = FLOWS.map.with_index { |val, idx| idx if val != 0 }.compact
part2 = two_max_current(VALVES.index("AA"), candidates, 26)

p [part1, part2]
