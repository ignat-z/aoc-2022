ORE      = 0
CLAY     = 1
OBISDIAN = 2
GEODE    = 3

def inplace(array, i, new_value)
  raise "oob" if i >= array.length
  array.slice(0...i) + [new_value] + array.slice(i + 1..)
end

MEM = {}
def max_geodes(id, t, robots, amounts, costs, maxs)
  state = [id, t, *robots, *amounts]

  return amounts[GEODE] if t == 0
  return MEM[state] if MEM.include?(state)

  MEM[state] = begin
    build_ore, build_ceil, build_obsidian, build_geode, build_nothing = [nil, nil, nil, nil, nil]

    if robots[ORE] < maxs[ORE]
      wait_til_ore = ((costs[ORE][ORE] - amounts[ORE]) / robots[ORE].to_f).ceil + 1
      build_ore = max_geodes(
        id, t - wait_til_ore,
        inplace(robots, ORE, robots[ORE] + 1),
        [
          amounts[ORE]      + (robots[ORE]      * wait_til_ore) - costs[ORE][ORE],
          amounts[CLAY]     + (robots[CLAY]     * wait_til_ore),
          amounts[OBISDIAN] + (robots[OBISDIAN] * wait_til_ore),
          amounts[GEODE]    + (robots[GEODE]    * wait_til_ore)
        ],
        costs,
        maxs
      ) if t - wait_til_ore >= 0 && wait_til_ore > 0
    end

    if robots[CLAY] < maxs[CLAY]
      wait_til_ceil = ((costs[CLAY][ORE] - amounts[ORE]) / robots[ORE].to_f).ceil + 1
      build_ceil = max_geodes(
        id, t - wait_til_ceil,
        inplace(robots, CLAY, robots[CLAY] + 1),
        [
          amounts[ORE]      + (robots[ORE]      * wait_til_ceil) - costs[CLAY][ORE],
          amounts[CLAY]     + (robots[CLAY]     * wait_til_ceil),
          amounts[OBISDIAN] + (robots[OBISDIAN] * wait_til_ceil),
          amounts[GEODE]    + (robots[GEODE]    * wait_til_ceil)
        ],
        costs,
        maxs
      ) if t - wait_til_ceil >= 0 && wait_til_ceil > 0
    end

    if robots[OBISDIAN] < maxs[OBISDIAN] && robots[CLAY] > 0
      wait_til_obisidan = [((costs[OBISDIAN][ORE] - amounts[ORE]) / robots[ORE].to_f).ceil, ((costs[OBISDIAN][CLAY] - amounts[CLAY]) / robots[CLAY].to_f).ceil].max + 1

      build_obsidian = max_geodes(
        id, t - wait_til_obisidan,
        inplace(robots, OBISDIAN, robots[OBISDIAN] + 1),
        [
          amounts[ORE]      + (robots[ORE]      * wait_til_obisidan) - costs[OBISDIAN][ORE],
          amounts[CLAY]     + (robots[CLAY]     * wait_til_obisidan) - costs[OBISDIAN][CLAY],
          amounts[OBISDIAN] + (robots[OBISDIAN] * wait_til_obisidan),
          amounts[GEODE]    + (robots[GEODE]    * wait_til_obisidan)
        ],
        costs,
        maxs
      ) if t - wait_til_obisidan >= 0 && wait_til_obisidan > 0
    end

    if robots[OBISDIAN] > 0
      wait_til_geode =  [((costs[GEODE][ORE] - amounts[ORE]) / robots[ORE].to_f).ceil, ((costs[GEODE][OBISDIAN] - amounts[OBISDIAN]) / robots[OBISDIAN].to_f).ceil].max + 1

      build_geode = max_geodes(
        id, t - wait_til_geode,
        inplace(robots, GEODE, robots[GEODE] + 1),
        [
          amounts[ORE]      + (robots[ORE]      * wait_til_geode) - costs[GEODE][ORE],
          amounts[CLAY]     + (robots[CLAY]     * wait_til_geode),
          amounts[OBISDIAN] + (robots[OBISDIAN] * wait_til_geode) - costs[GEODE][OBISDIAN],
          amounts[GEODE]    + (robots[GEODE]    * wait_til_geode)
        ],
        costs,
        maxs
      ) if t - wait_til_geode >= 0 && wait_til_geode > 0
    end

    build_nothing = max_geodes(
      id, t - 1,
      robots,
      [
        amounts[ORE]      + robots[ORE],
        amounts[CLAY]     + robots[CLAY],
        amounts[OBISDIAN] + robots[OBISDIAN],
        amounts[GEODE]    + robots[GEODE]
      ],
      costs,
      maxs
    ) if t - 1 >= 0

    [build_ore, build_ceil, build_obsidian, build_geode, build_nothing].compact.max
  end
end



lines = File.read("input.txt").split("\n").map(&:strip)

total = 0
lines.each do |line|
  id, ore_robot_ore_cost, clay_robot_ore_cost, obsidian_robot_ore_cost, obsidian_robot_clay_cost, geode_robot_ore_cost, geode_robot_obsidian_cost = line.scan(/\d+/).map(&:to_i)

  costs = [
    [ore_robot_ore_cost, 0, 0],
    [clay_robot_ore_cost, 0, 0],
    [obsidian_robot_ore_cost, obsidian_robot_clay_cost, 0],
    [geode_robot_ore_cost, 0, geode_robot_obsidian_cost]
  ]

  maxs = [
    [costs[ORE][ORE], costs[CLAY][ORE], costs[OBISDIAN][ORE], costs[GEODE][ORE]].max,
    [costs[OBISDIAN][CLAY]].max,
    [costs[GEODE][OBISDIAN]].max
  ]

  max = max_geodes(id, 24, [1, 0, 0, 0], [0, 0, 0, 0], costs, maxs)
  p [id, max]

  total += id * max
end

part1 = total
p part1


total = 1
lines.first(3).each do |line|
  id, ore_robot_ore_cost, clay_robot_ore_cost, obsidian_robot_ore_cost, obsidian_robot_clay_cost, geode_robot_ore_cost, geode_robot_obsidian_cost = line.scan(/\d+/).map(&:to_i)

  costs = [
    [ore_robot_ore_cost, 0, 0],
    [clay_robot_ore_cost, 0, 0],
    [obsidian_robot_ore_cost, obsidian_robot_clay_cost, 0],
    [geode_robot_ore_cost, 0, geode_robot_obsidian_cost]
  ]

  maxs = [
    [costs[ORE][ORE], costs[CLAY][ORE], costs[OBISDIAN][ORE], costs[GEODE][ORE]].max,
    [costs[OBISDIAN][CLAY]].max,
    [costs[GEODE][OBISDIAN]].max
  ]

  max = max_geodes(id, 32, [1, 0, 0, 0], [0, 0, 0, 0], costs, maxs)
  p [id, max]

  total *= max
end

part2 = total
p part2

p [part1, part2]
