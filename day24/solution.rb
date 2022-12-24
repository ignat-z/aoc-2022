# input = File.read("sample.txt")
input = File.read("input.txt")

VOID = 0
WALL = 1
NORTH = 2
SOUTH = 3
EAST = 4
WEST = 5

input = input.delete("\r")
map = input.split("\n")
map.map!(&:rstrip)

map.map! {
  _1.chars.map { |val|
    case val
    when "." then VOID
    when "#" then WALL
    when "^" then NORTH
    when "v" then SOUTH
    when ">" then EAST
    when "<" then WEST
    end
  }
}

def print_map(map, blizzards, player)
  to_check = blizzards.map { _1.first(2) }
  map.each_with_index do |row, y|
    puts row.map.with_index { |val, x|
      next('#') if val == WALL
      if to_check.include?([x, y])
        count = to_check.count { _1 == [x, y] }
        if count > 1
          count.to_s
        else
          new_val = blizzards.find { _1.first(2) == [x, y] }
          case new_val[2]
          when NORTH then "^"
          when SOUTH then "v"
          when EAST then ">"
          when WEST then "<"
          end
        end
      else
        '.'
      end
    }.join
  end
  puts
end

def find_blizzards(map)
  agg = []
  map.each_with_index do |row, y|
    row.each_with_index do |val, x|
      agg << [x, y] if [NORTH, SOUTH, EAST, WEST].include?(val)
    end
  end
  agg
end

require 'set'

MEM = {}
def step(map, blizzards, steps)
  return MEM[steps] if MEM[steps]
  steps.times do
    blizzards = blizzards.map { |(x, y, blizzard)|
      nx, ny = nil
      case blizzard
      when NORTH
        nx = x
        ny = y - 1
        ny = map.length - 2 if map[ny][nx] == WALL
      when SOUTH
        nx = x
        ny = y + 1
        ny = 1 if map[ny][nx] == WALL
      when EAST
        nx = x + 1
        ny = y
        nx = 1 if map[ny][nx] == WALL
      when WEST
        nx = x - 1
        ny = y
        nx = map[0].length - 2 if map[ny][nx] == WALL
      end
      [nx, ny, blizzard]
    }
  end
  MEM[steps] = blizzards.map { _1.first(2) }.to_set
end

def shortest_path(map, blizzards, from, to, t)
  positions = [from]
  loop do
    break if positions.include?(to)
    t += 1

    current_blizzards = step(map, blizzards, t)
    next_positions = Set.new
    positions.each do |player|
      x,y = player
      [[-1, 0], [1, 0], [0, 1], [0, -1], [0, 0]].each do |(dx, dy)|
        nx, ny = x + dx, y + dy

        next if nx < 0 || nx > map[0].length - 1
        next if ny < 0 || ny > map.length - 1
        next if map[ny][nx] == WALL
        next if current_blizzards.include?([nx, ny])
        next_positions << [nx, ny]
      end
    end
    positions = next_positions
  end
  t
end

start = [1, 0]
finish = [map.last.index(VOID), map.length - 1]
blizzards = find_blizzards(map).map { |(x, y)| [x, y, map[y][x]] }

t1 = shortest_path(map, blizzards, start, finish, 0)
t2 = shortest_path(map, blizzards, finish, start, t1)
t3 = shortest_path(map, blizzards, start, finish, t2)

p [t1, t3]
