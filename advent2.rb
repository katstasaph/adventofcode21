# part 1

position = 0
depth = 0

moves = File.read('advent2.txt').split("\n").map { |move| move.split }
moves.each do |move|
  case move[0]
  when "forward" then position += move[1].to_i
  when "up" then depth -= move[1].to_i
  when "down" then depth += move[1].to_i
  end
end
p (position * depth)

# part 2

position = 0
aim = 0
depth = 0

moves = File.read('advent2.txt').split("\n").map { |move| move.split }
moves.each do |move|
  case move[0]
  when "forward"
    position += move[1].to_i
    depth += (move[1].to_i * aim)
  when "up"
    aim -= move[1].to_i
  when "down"
    aim += move[1].to_i
  end
end
p (position * depth)