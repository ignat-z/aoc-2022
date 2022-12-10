input = File.read("input.txt")
CYCLES = [20, 60, 100, 140, 180, 220]
commands = input.strip.split("\n").map(&:strip)


registers = {:X => 1}
current_cycle = 0
total = 0

def inc(cycle, val)
  val.times do
    cycle += 1
    yield(cycle) if block_given?
  end
  cycle
end

commands.each do |command|
  case command
  in "noop"
    current_cycle = inc(current_cycle, 1) { |cycle| total += cycle * registers[:X] if CYCLES.include?(cycle) }
  in /addx/
    val = command.split(" ").last.to_i
    current_cycle = inc(current_cycle, 2) { |cycle| total += cycle * registers[:X] if CYCLES.include?(cycle) }
    registers[:X] += val
  else
    raise "Unknown command"
  end
end

part1 = total
p part1


pixels = []
registers = {:X => 1}
current_cycle = 0

def char_at(cpu_cycle, registers)
  crt_cycle = (cpu_cycle - 1) % 40
  [registers[:X] - 1, registers[:X], registers[:X] + 1].include?(crt_cycle) ? "#" : "."
end

commands.each do |command|
  case command
  in "noop"
    current_cycle = inc(current_cycle, 1) { |cycle| pixels << char_at(cycle, registers) }
  in /addx/
    current_cycle = inc(current_cycle, 2) { |cycle| pixels << char_at(cycle, registers) }
    val = command.split(" ").last.to_i
    registers[:X] += val
  else
    raise "Unknown command"
  end
end

pixels.each_slice(40).each { puts _1.join }
