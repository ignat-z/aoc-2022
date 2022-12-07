input = File.read("input.txt").split("\n").map(&:strip)

class Record
  attr_accessor :name, :size, :parent, :children, :dir

  def initialize
    @children = []
    @dir = true
  end

  def full_path
    return '/' if parent.nil?
    names = []
    current = parent
    while current && current.name != "/"
      names << current.name
      current = current.parent
    end
    '/' + (names.reverse + [name]).join("/")
  end

  def size
    return @size unless dir
    children.sum(&:size)
  end
end

cursor = 0
current_dir = nil
root = nil

loop do
  break if cursor >= input.length

  line = input[cursor]
  if line.start_with?("$ cd")
    path = line.delete_prefix("$ cd ")
    current_dir = if path == "/"
      record = Record.new
      record.name = path

      root = record
      root
    elsif path == ".."
      current_dir.parent
    else
      current_dir.children.find { _1.name == path && _1.dir }
    end

    cursor += 1
  elsif line.start_with?("$ ls")
    output = input.slice((cursor + 1)..).take_while { !_1.start_with?("$") }
    output.each do |out_line|
      record = Record.new
      if out_line.start_with?("dir")
        _dir, name = out_line.split(" ")
        record.name = name
        record.parent = current_dir
      else
        size, name = out_line.split(" ")
        record.name = name
        record.size = size.to_i
        record.dir = false
      end
      current_dir.children << record
    end

    cursor += (1 + output.size)
  else
    raise "Unknown command #{line}"
  end
end

sizes = {}
queue = [root]
while !queue.empty? do
  current = queue.pop
  sizes[current.full_path] = current.size
  current.children.select(&:dir).each { queue << _1 }
end

part1 = sizes.values.select { _1 <= 100_000 }.sum

total   = 70_000_000
need    = 30_000_000
unused  = total - sizes["/"]
to_delete = need - unused

part2 = sizes.values.select { _1 > to_delete }.min

p [part1, part2]
