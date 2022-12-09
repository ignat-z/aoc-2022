input = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
""".strip
input = File.read("input.txt")
route = input.split("\n").map { _1.strip.split(" ") }.map { |(dir, count)| [dir, count.to_i] }

require 'set'

def dst(head, tail)
  x1, y1 = head
  x2, y2 = tail
  [(x1 - x2).abs, (y1 - y2).abs].max
end


visited = Set.new

head = [0, 0]
tail = [0, 0]

route.each do |dir, count|
  count.times do
    hx, hy = head
    tx, ty = tail

    dx, dy = 0, 0

    case dir
    when "R" then dx =  1
    when "L" then dx = -1
    when "U" then dy =  1
    when "D" then dy = -1
    end

    head = [hx + dx, hy + dy]
    tail = [hx, hy] if (dst(head, tail) > 1)
    visited << tail
  end
end

part1 = visited.count









def adj(head, tail)
  x1, y1 = head
  x2, y2 = tail
  [(x1 - x2).abs, (y1 - y2).abs].max

  [
    x2 + (x1 - x2).clamp(-1, 1),
    y2 + (y1 - y2).clamp(-1, 1)
  ]
end




visited = Set.new

state = [[0, 0]] * 10

route.each do |dir, count|
  count.times do
    head, *tails = state

    hx, hy = head
    dx, dy = 0, 0
    case dir
    when "R" then dx =  1
    when "L" then dx = -1
    when "U" then dy =  1
    when "D" then dy = -1
    end
    head = [hx + dx, hy + dy]


    new_tails = []
    tails.reduce(head) do |nhead, ntail|
      ntail = adj(nhead, ntail) if dst(nhead, ntail) > 1
      new_tails << ntail
      ntail
    end

      visited << new_tails.last
      state = [head, *new_tails]
  end
end

part2 = visited.count


p [part1, part2]
