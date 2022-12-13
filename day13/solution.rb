# input = File.read("sample.txt")
input = File.read("input.txt")

def ordered?(left, right)
  left = left.dup
  right = right.dup

  case [left, right]
  in [Integer, nil]
    [false, :stop]
  in [nil, Integer]
    [true, :stop]
  in [Integer, Integer]
    if left < right
      [true, :stop]
    elsif left > right
      [false, :stop]
    else
      [true, :cont]
    end
  in [Array, Array]
    left << nil while left.size < right.size
    right << nil while right.size < left.size

    all = left.zip(right).all? { |(l, r)|
      return [true, :stop] if l.nil?
      return [false, :stop] if r.nil?
      result, kind = ordered?(l, r)
      if kind == :stop
        return [result, :stop]
      else
        result
      end
    }
    if all
      [true, :cont]
    else
      [false, :stop]
    end
  in [Integer, Array]
    ordered?(Array(left), Array(right))
  in [Array, Integer]
    ordered?(Array(left), Array(right))
  end
end

pairs = input
    .strip
    .gsub("\r\n", "\n").split("\n\n")
    .map { _1.gsub("\n", ",") }
    .map { l, r = instance_eval('[' + _1 + ']') }

def decide(result)
  result, type = result
  raise "Unknown" if type != :stop
  result
end

part1 = pairs.map.with_index { |pair, idx|
  left, right = pair
  decide(ordered?(left, right)) ? idx + 1 : nil
}.compact.sum

signals = pairs.flatten(1) + [[[2]], [[6]]]
sorted = signals.sort { |a, b|
  next(1) if a == b
  decide(ordered?(a.dup, b.dup)) ? -1 : 1
}

part2 = (sorted.index([[2]]) + 1) * (1 + sorted.index([[6]]))
p [part1, part2]
