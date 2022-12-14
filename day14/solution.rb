# require 'bundler/inline'

# gemfile(true) do
#   source 'https://rubygems.org'
#   gem 'chunky_png'
#   gem 'pry'
# end
# require 'chunky_png'
# ZOOM = 5

EMPTY = 0
ROCK  = 1
SAND  = 2

START = [500, 0]

MAX_X = 1024
MAX_Y = 200

# def show(matrix)
#   png = ChunkyPNG::Image.new(MAX_X * ZOOM + 1, MAX_Y * ZOOM + 1, ChunkyPNG::Color::TRANSPARENT)
#   (0...MAX_Y).each do |y|
#     (0...MAX_X).each do |x|
#       color = case matrix[y].to_a[x] || EMPTY
#       when EMPTY then ChunkyPNG::Color.rgba(255, 255, 255, 255)
#       when ROCK then ChunkyPNG::Color.rgba(0, 0, 0, 255)
#       when SAND then ChunkyPNG::Color.rgba(255, 0, 0, 255)
#       end
#       (x * ZOOM..(x + 1) * ZOOM).each do |zx|
#         (y * ZOOM..(y + 1) * ZOOM).each do |zy|
#           png[zx, zy] = color
#         end
#       end
#     end
#   end

#   png.save('/mnt/d/filename.png')
# end

input = File.read("sample.txt")
input = File.read("input.txt")

pathes = input
  .split("\n")
  .map { _1.strip.split(" -> ") }
  .map { _1.map { |coordinates| coordinates.split(",").map(&:to_i) }}

def get_field(pathes)
  field = Array.new(MAX_Y) { Array.new(MAX_X, EMPTY) }
  bottom = 0

  pathes.each do |path|
    path.each_cons(2) do |(fx, fy), (tx, ty)|
      Range.new(*[fx, tx].sort).each do |x|
        Range.new(*[fy, ty].sort).each do |y|
          bottom = [bottom, y].max
          field[y][x] = ROCK
        end
      end
    end
  end

  [field, bottom]
end

field, bottom = get_field(pathes)

counter = 0
abuss = false
while !abuss do
  counter += 1
  x, y = START
  moves = true
  while moves do
    if field[y + 1][x] == EMPTY
      y += 1
    else
      if field[y + 1][x - 1] == EMPTY
        y += 1
        x -= 1
      elsif field[y + 1][x + 1] == EMPTY
        y += 1
        x += 1
      else
        moves = false
      end
    end

    if y > bottom
      abuss = true
      moves = false
    end
  end
  field[y][x] = SAND
end

part1 = counter - 1



field, bottom = get_field(pathes)
bottom += 2
(0..MAX_X).each { field[bottom][_1] = ROCK }

counter = 0
stack = false
while !stack do
  counter += 1
  x, y = START
  moves = true
  while moves do
    if field[y + 1][x] == EMPTY
      y += 1
    else
      if field[y + 1][x - 1] == EMPTY
        y += 1
        x -= 1
      elsif field[y + 1][x + 1] == EMPTY
        y += 1
        x += 1
      else
        moves = false
      end
    end

    if y >= bottom
      moves = false
    end
  end
  if y == 0
    stack = true
  end
  field[y][x] = SAND
end

part2 = counter

p [part1, part2]
