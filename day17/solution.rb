# PATTERN = '>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>'.chars.cycle
PATTERN = File.read("input.txt").strip.chars.cycle

HBAR    = [[0, 0], [0, 1], [0, 2], [0, 3]]
CROSS   = [[0, 1], [1, 0], [1, 1], [1, 2], [2, 1]]
CORNER  = [[0, 0], [0, 1], [0, 2], [1, 2], [2, 2]]
VBAR    = [[0, 0], [1, 0], [2, 0], [3, 0]]
BOX     = [[0, 0], [0, 1], [1, 0], [1, 1]]

FIGURES = [HBAR, CROSS, CORNER, VBAR, BOX].cycle

X_OFFSET   = 2
Y_OFFSET   = 3
WIDE       = 7
P1_LIMIT   = 2022
P2_LIMIT   = 1_000_000_000_000
MAX_HEIGHT = 400

EMPTY = 0
FILLED = 1
FALLS = 2

field = Array.new(MAX_HEIGHT) { Array.new(WIDE, EMPTY) }
field[0] = [FILLED] * WIDE
current_top = 1

def print_field(field)
  field.drop(1).reverse.each do |row|
    puts '|'+row.map {
      case _1
      when EMPTY then '.'
      when FILLED then '#'
      when FALLS then '@'
      else raise "Unknown field state"
      end
    }.join+'|'
  end
  puts (['+'] + ['-']*WIDE + ['+']).join
end

def can_move_right?(figure, field)
  xs = figure.map(&:last)
  xs.max < WIDE - 1 && !figure.map { |y, x| field[y][x + 1] }.any? { _1 == FILLED }
end

def can_move_left?(figure, field)
  xs = figure.map(&:last)
  xs.min > 0 && !figure.map { |y, x| field[y][x - 1] }.any? { _1 == FILLED }
end

def can_move_down?(figure, field)
  !figure.map { |y, x| field[y - 1][x] }.any? { _1 == FILLED }
end

def move_right(figure, field)
  raise unless can_move_right?(figure, field)
  figure.map {|y, x| [y, x + 1] }
end

def move_left(figure, field)
  raise unless can_move_left?(figure, field)
  figure.map {|y, x| [y, x - 1] }
end

def move_down(figure, field)
  raise "Can't move down" unless can_move_down?(figure, field)
  figure.map {|y, x| [y - 1, x]}
end

def draw(field, figure, fallen = true)
  figure.each { |(y, x)| field[y][x] = fallen ? FILLED : FALLS }
end

def copy_field(field)
  Marshal.load(Marshal.dump(field))
end


$dropped = []

def drop_field(field)
  to_drop = (1...MAX_HEIGHT).find {
    break(nil) if field[_1].all? { |cell| cell == EMPTY }
    field[_1].all? { |cell| cell == FILLED }
  }
  return 0 unless to_drop

  field.shift(to_drop)
  to_drop.times { field << Array.new(WIDE, EMPTY) }

  to_drop
end

def print_temp(field, figure = nil)
  copy = copy_field(field)
  draw(copy, figure, fallen = false) if figure
  print_field(copy)
end

current_figure = nil
should_fall    = true
t = 0
dropped = 0

STATES  = []
DROPS   = []
STACKED = []

loop do
  if !current_figure
    current_figure = FIGURES.next
    t += 1

    break if t - 1 == P2_LIMIT
    current_figure = current_figure.map { |(y, x)| [y + current_top + Y_OFFSET, x + X_OFFSET] }
    should_fall = false
  end

  if can_move_down?(current_figure, field)
    current_figure = move_down(current_figure, field) if should_fall
  end
  should_fall = true

  if current_figure
    current_move = PATTERN.next
    if current_move == '>'
      current_figure = move_right(current_figure, field) if can_move_right?(current_figure, field)
    else
      current_figure = move_left(current_figure, field) if can_move_left?(current_figure, field)
    end
  end

  if !can_move_down?(current_figure, field)
    draw(field, current_figure)
    current_figure = nil

    mfield = Marshal.dump(field)
    if t > 1 && STATES.include?(mfield)
      STATES.clear

      while t + 1372 + 1225 < P2_LIMIT
        t += 890
        dropped += 1372
        # p [t, dropped]
        t += 815
        dropped += 1225
        # p [t, dropped]
      end
    end

    to_drop = drop_field(field)
    dropped += to_drop

    STATES << mfield
    DROPS  << to_drop
    STACKED << (t - (STACKED.sum || 0))

    current_top = (0..MAX_HEIGHT).find { !field[_1].include?(FILLED) }
  end
end

part2 = dropped + current_top - 1
