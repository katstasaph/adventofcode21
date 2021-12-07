# The basic algorithm:
# The geometric median of a set of points is the point closest to all of those points
# In 1 dimension this is just the median, and in part 1 that is all we need to find.
# Part 2 scales the distance, the new distance from a point is now (1 + 2 + 3 ... + n), or (n)(n + 1) / 2
# We start with our original median as our initial guess, and check increasing/decreasing medians until we reach the best guess
# To determine whether our median is higher/lower we check whether our set is skewed left or right
# (This algorithm may need to account for the case where the original median is still the best guess -- is that possible?)
# (At the very least it is not the case here)

def middle_index(arr)
  (arr.length + 1) / 2
end

def skewed_right?(arr, median_index)
  front_sum = arr.take(median_index).inject(:+)
  back_sum = arr.drop(median_index).inject(:+)
  front_sum < back_sum
end

def triangular_number(num)
  (num * (num + 1)) / 2
end

def adjusted_geometric_median(positions, median, additional_distance)
  positions.inject(0) { |sum, position| sum + (median - position).abs } + additional_distance
end

positions = File.read('advent7.txt').split(",").to_a.map { |num| num.to_i }.sort
median_index = middle_index(positions)
median = positions[median_index]

# day 1

p adjusted_geometric_median(positions, median, 0)

# day 2

adding = skewed_right?(positions, median_index)
best_distance = nil
loop do
  additional_distance = 0 
  positions.each do |position|
    distance = (median - position).abs
    weighted_distance = triangular_number(distance)
    additional_distance += (weighted_distance - distance)
  end
  distance = adjusted_geometric_median(positions, median, additional_distance)
  if !best_distance
    best_distance = distance
  elsif best_distance <= distance
    break
  else
    best_distance = distance
  end
  adding ? median += 1 : median -= 1
end
p best_distance