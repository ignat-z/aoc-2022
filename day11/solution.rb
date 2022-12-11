input = File.read("input.txt").strip

monkeys = input.split("\n").map(&:strip).each_slice(7).to_a.map { _1.reject(&:empty?) }

original_items = monkeys.map { |monkey| monkey.find { _1.include?("Starting items") }.delete_prefix("Starting items: ").split(", ").map(&:to_i) }
operations = monkeys.map { |monkey| monkey.find { _1.include?("Operation: new =") }.delete_prefix("Operation: new = ") }
tests = monkeys.map { |monkey| monkey.find { _1.include?("Test: divisible by") }.delete_prefix("Test: divisible by ").to_i }
if_true = monkeys.map { |monkey| monkey.find { _1.include?("If true: throw to monkey ") }.delete_prefix("If true: throw to monkey ").to_i }
if_false = monkeys.map { |monkey| monkey.find { _1.include?("If false: throw to monkey ") }.delete_prefix("If false: throw to monkey ").to_i }

processed = Array.new(monkeys.count, 0)
items = original_items.map(&:dup)

20.times do |round|
  monkeys.each_with_index do |_, idx|
    while !items[idx].empty? do
      processed[idx] += 1
      current_item = items[idx].shift
      old = current_item
      result = eval(operations[idx])
      result /= 3

      if result % tests[idx] == 0
        items[if_true[idx]] << result
      else
        items[if_false[idx]] << result
      end
    end
  end
end

part1 = processed.sort.last(2).inject(&:*)

processed = Array.new(monkeys.count, 0)
items = original_items.map(&:dup)
lcm = tests.reduce(1, :lcm)

10_000.times do |round|
  monkeys.each_with_index do |_, idx|
    while !items[idx].empty? do
      processed[idx] += 1
      current_item = items[idx].shift
      old = current_item
      result = eval(operations[idx])
      result %= lcm

      if result % tests[idx] == 0
        items[if_true[idx]] << result
      else
        items[if_false[idx]] << result
      end
    end
  end
end

part2 = processed.sort.last(2).inject(&:*)

p [part1, part2]
