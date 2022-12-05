require 'strscan'

input = File.read("input.txt")
ops, descriptions = input.lines.partition { _1.start_with?("move") }

def read_decks(descriptions)
  decks = {}
  descriptions.each do |line|
    next if line.strip.empty?
    next if line.strip.match?(/\d /)

    line.chomp.chars.each_slice(4).each_with_index do |group, idx|
      next if group.join.strip.empty?
      decks[idx + 1] ||= []
      decks[idx + 1] << group.join.gsub(/[^A-Z]/i, '')
    end
  end
  decks
end

def move(ops, decks, cm9001 = false)
  ops
    .map { |instruction|
      s = StringScanner.new(instruction)
      s.scan("move ")
      amount = s.scan(/\d+/).to_i
      s.scan(" from ")
      from = s.scan(/\d+/).to_i
      s.scan(" to ")
      to = s.scan(/\d+/).to_i

      [amount, from, to]
    }.map { |amount, from, to|
      up = decks[from].shift(amount)
      cm9001 ? decks[to].unshift(*up) : decks[to].unshift(*up.reverse)
    }

  decks.sort_by(&:first).map(&:last).map(&:first).join
end

part1 = move(ops, read_decks(descriptions))
part2 = move(ops, read_decks(descriptions), true)

p [part1, part2]
