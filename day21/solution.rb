input = File.read("sample.txt")
input = File.read("input.txt")

def deep_clone(obj)
  Marshal.load(Marshal.dump(obj))
end

def part1(q, nodes)
  while !q.empty? do
    current = q.shift
    key, left, right, operation = current
    if nodes.include?(left) && nodes.include?(right)
      nodes[key] = [nodes.fetch(left), nodes.fetch(right)].reduce(operation.to_sym)
    else
      q << current
    end
  end

  nodes["root"]
end

nodes = {}
q = []

input.strip.split("\n").each do |line|
  key, value = line.chomp.split(": ")
  raise if nodes.include?(key)
  if value.match?(/\d+/)
    nodes[key] = value.to_i
  else
    operation = value.match(/ (.) /)[1]
    left, right = value.split(/ . /)
    q << [key, left, right, operation]
  end
end

part1 = part1(deep_clone(q), deep_clone(nodes))

class Node
  def initialize(key, left, right, value, operation)
    @key, @left, @right, @value, @operation = key, left, right, value, operation
  end

  attr_accessor :key, :left, :right, :value, :operation

  def calc
    raise "You can't calculate this value yet" if key == "humn"
    return value if value
    [left.calc, right.calc].reduce(operation.to_sym)
  end

  def computable?
    val = calc rescue false
    !!val
  end
end

nodes.each { |k, v| nodes[k] = Node.new(k, nil, nil, v.to_f, nil) }

while !q.empty? do
  current = q.shift
  key, left, right, operation = current
  if nodes.include?(left) && nodes.include?(right)
    nodes[key] = Node.new(key, nodes.fetch(left), nodes.fetch(right), nil, operation.to_sym)
  else
    q << current
  end
end

if nodes["root"].right.computable?
  expected = nodes["root"].right.calc
  current = nodes["root"].left
else
  expected = nodes["root"].left.calc
  current = nodes["root"].right
end


def reverse_calc(left, right, expected, operation)
  if left.nil?
    case operation
    when :+ then expected - right
    when :* then expected / right
    when :- then expected + right
    when :/ then expected * right
    else raise "unk"
    end
  else
    case operation
    when :+ then expected - left
    when :* then expected / left
    when :- then left - expected
    when :/ then left / expected
    else raise "unk"
    end
  end
end


part2 = loop {
  left, right, operation = current.left, current.right, current.operation

  if [left.key, right.key].include?('humn')
    break(if left.key == "humn"
      reverse_calc(nil, right.calc, expected, operation)
    else
      reverse_calc(left.calc, nil, expected, operation)
    end)
  end

  if left.computable?
    expected = reverse_calc(left.calc, nil, expected, operation)
    current = current.right
  else
    expected = reverse_calc(nil, right.calc, expected, operation)
    current = current.left
  end
}.to_i

p [part1, part2]
