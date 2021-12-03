# part 1

larger_measurements = 0
depths = File.read('advent1.txt').split("\n")
depths.each_with_index do |depth, i|
   larger_measurements += 1 if depths[i + 1] && depth.to_i < depths[i + 1].to_i
end

# part 2

larger_measurements = 0
depths = File.read('advent1.txt').split("\n")
last_depths = depths.slice!(0, 3)
depths.each_with_index do |depth, i|
  larger_measurements += 1 if depth.to_i > last_depths[0].to_i
  last_depths.slice!(0, 1) 
  last_depths << depth
end
p larger_measurements