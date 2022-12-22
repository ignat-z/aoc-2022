VOID = 0
OPEN = 1
WALL = 2

# input = File.read('sample.txt')
input = File.read("input.txt")
input = input.delete("\r")
map, path = input.split("\n\n")
map = map.split("\n")
map.map!(&:rstrip)

map.map! {
  _1.chars.map { |val|
    case val
    when " " then VOID
    when "." then OPEN
    when "#" then WALL
    end
  }
}

def print_map(map, player)
  map.each_with_index do |row, y|
    puts row.map.with_index { |val, x|
      next("P") if player == [x, y]
      case val
      when VOID then " "
      when OPEN then "."
      when WALL then "#"
      end
    }.join
  end
  puts
end

def step(x, y, facing)
  case facing
  when 0 then [x + 1, y]
  when 1 then [x, y + 1]
  when 2 then [x - 1, y]
  when 3 then [x, y - 1]
  end
end

def find_start(map)
  map.each_with_index do |row, y|
    row.each_with_index do |val, x|
      return [x, y] if val == OPEN
    end
  end
end

def draw_faces(map, faces, player)
  map.each_with_index do |row, y|
    puts row.map.with_index { |val, x|
      next("P") if player == [x, y]
      case val
      when VOID then " "
      else
        faces.find { |(k, v)| k[0].include?(x) && k[1].include?(y) }[1] || (raise "unknown face")
      end
    }.join
  end

  raise if faces.keys.map { |(xr, yr)| xr.size * yr.size }.uniq.count > 1
end

def make_step(map, player, next_step, facing)
  max_x = map.first.length
  max_y = map.length

  nx, ny = next_step
  nx %= max_x
  ny %= max_y
  return player if map[ny][nx] == WALL

  if map[ny][nx].nil? || map[ny][nx] == VOID

    vx, vy = step(nx % max_x, ny % max_y, facing)
    vx %= max_x
    vy %= max_y

    return make_step(map, player, [vx, vy], facing)
  end

  next_step
end

player = find_start(map)
facing = 0

path.scan(/(\d+)([RL]?)/).each do |(count, turn)|
  count = count.to_i

  count.times do
    x, y = player
    next_step = step(x, y, facing)
    player = make_step(map, player, next_step, facing)
  end

  facing = (turn == "R" ? facing + 1 : facing - 1) % 4 unless turn.empty?
end

x, y = player
part1 = [1_000 * (y + 1), 4 * (x + 1), facing].sum

face_length = Math.sqrt(map.flatten.count { _1 != VOID } / 6)
raise unless face_length.ceil == face_length.to_i
face_length = face_length.to_i

player = find_start(map)
facing = 0

faces = {
  [(0..face_length - 1), (0..face_length - 1)] => 1,
  [(0..face_length - 1), (face_length..face_length * 2 - 1)] => 2,
  [(0..face_length - 1), (face_length * 2..face_length * 3 - 1)] => 3,
  [(0..face_length - 1), (face_length * 3..)] => 4,
  [(face_length..face_length * 2 - 1), (0..face_length - 1)] => 5,
  [(face_length..face_length * 2 - 1), (face_length..face_length * 2 - 1)] => 6,
  [(face_length..face_length * 2 - 1), (face_length * 2..face_length * 3 - 1)] => 7,
  [(face_length..face_length * 2 - 1), (face_length * 3..)] => 8,
  [(face_length * 2..face_length * 3 - 1), (0..face_length - 1)] => 9,
  [(face_length * 2..face_length * 3 - 1), (face_length..face_length * 2 - 1)] => "a",
  [(face_length * 2..face_length * 3 - 1), (face_length * 2..face_length * 3 - 1)] => "b",
  [(face_length * 2..face_length * 3 - 1), (face_length * 3..)] => "c",
  [(face_length * 3..), (0..face_length - 1)] => "d",
  [(face_length * 3..), (face_length..face_length * 2 - 1)] => "e",
  [(face_length * 3..), (face_length * 2..face_length * 3 - 1)] => "f",
  [(face_length * 3..), (face_length * 3..)] => "g"
}

def find_face(faces, x, y)
  face = faces.find { |(k, v)| k[0].include?(x) && k[1].include?(y) }[1]
  raise unless face
  face.to_s
end

def wrap_y(faces, next_step, facing)
  x, y = next_step

  case [x, y]
  in [(0..49), (..99)] then [50, x + 50, (facing + 1) % 4] # from 3 up
  in [(0..49), (200..)] then [x + 100, 0, facing] # from 4 down
  in [(50..99), (...0)] then [0, x + 100, (facing + 1) % 4] # from 5 up
  in [(50..99), (150..)] then [49, x + 100, (facing + 1) % 4] # from 7 down
  in [(100..149), (...0)] then [x - 100, 199, facing] # from 9 up
  in [(100..149), (50..)] then [99, x - 50, (facing + 1) % 4] # from 9 down
  else [x, y, facing]
  end
end

def wrap_x(faces, next_step, facing)
  x, y = next_step

  case [x, y]
  in [(...0), (100..149)] then [50, 149 - y, (facing + 2) % 4] # from 3 left
  in [(...0), (150..199)] then [y - 100, 0, (facing + 3) % 4] # from 4 left
  in [(50..99), (150..199)] then [y - 100, 149, (facing + 3) % 4] # from 4 right
  in [(0..49), (0..49)] then [0, 149 - y, (facing + 2) % 4] # from 5 left
  in [(0..49), (50..99)] then [y - 50, 100, (facing + 3) % 4] # from 6 left
  in [(100..), (50..99)] then [y + 50, 49, (facing + 3) % 4] # from 6 right
  in [(100..), (100..149)] then[149, 149 - y, (facing + 2) % 4] # from 7 right
  in [(150..), (0..49)] then [99, 149 - y, (facing + 2) % 4] # from 9 right
  else [x, y, facing]
  end
end

path.scan(/(\d+)([RL]?)/).each do |(count, turn)|
  count.to_i.times do
    x, y = player
    next_step = step(x, y, facing)

    if facing % 2 == 0
      nx, ny, nfacing = wrap_x(faces, next_step, facing)
    else
      nx, ny, nfacing = wrap_y(faces, next_step, facing)
    end

    if map[ny][nx] != WALL
      player = nx, ny
      facing = nfacing
    end
  end

  facing = (turn == "R" ? facing + 1 : facing - 1) % 4 unless turn.empty?
end

x, y = player
part2 = [1_000 * (y + 1), 4 * (x + 1), facing].sum

p [part1, part2]
