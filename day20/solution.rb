input = [1,2,-3,3,-2,0,4]
input = File.read("input.txt").split("\n").map(&:to_i)
n = input.size

buffer = input.zip((0..))
input.each_with_index do |val, idx|
  pair = [val, idx]
  buffer.rotate!(buffer.index(pair))
  buffer.shift
  buffer.rotate!(val % (n - 1))
  buffer.unshift(pair)
end

buffer.rotate!(-1) until buffer[0][0].zero?
part1 = [1000, 2000, 3000].map { |idx| buffer[idx % n][0] }.sum

decryption_key = 811589153
decrypted = input.map { _1 * decryption_key }
buffer = decrypted.zip((0..))
10.times do
  decrypted.each_with_index do |val, idx|
    pair = [val, idx]
    buffer.rotate!(buffer.index(pair))
    buffer.shift
    buffer.rotate!(val % (n - 1))
    buffer.unshift(pair)
  end
end

buffer.rotate!(-1) until buffer[0][0].zero?
part2 = [1000, 2000, 3000].map { |idx| buffer[idx % n][0] }.sum

p [part1, part2]
