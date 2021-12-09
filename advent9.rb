ROW_LENGTH = 100

def get_adjacent_values(row, row_index, columns, column_index)
  adjacents = [row[column_index + 1], columns[column_index][row_index + 1]]
  if column_index != 0 then adjacents << row[column_index - 1] end
  if row_index != 0 then adjacents << columns[column_index][row_index - 1] end
  adjacents
end

def possible_basin_points(x, y, contiguous, used = [])
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].reject { |point| point[0] < 0 || point[1] < 0 || !contiguous.include?(point) || used.include?(point) }
end

def find_all_basins(contiguous_indexes)
  basins = []
  basin_points = []
  loop do
    start_point = contiguous_indexes[0]
    adjacent_points = possible_basin_points(start_point[0], start_point[1], contiguous_indexes)
    basin_points = find_basin(contiguous_indexes, adjacent_points)
    contiguous_indexes.reject! { |index| basin_points.include?(index) }
    basins << basin_points
    break if contiguous_indexes.empty?
    end
  basins
end

def find_basin(contiguous_indexes, adjacent_points, basin_points=[])
  return basin_points if adjacent_points.empty?
  loop do
    adjacent_points.each do |point|
      next if basin_points.include?(point)
      basin_points << point
      adjacent_basin_points = possible_basin_points(point[0], point[1], contiguous_indexes, basin_points)
      new_basin_points = find_basin(contiguous_indexes, adjacent_basin_points, basin_points)
    end
    return basin_points
  end
end

# part 1

height_map = File.read('advent9.txt').split.map { |row| row.chars.map { |chr| chr.to_i }}
risk_index = 0
columns = height_map.transpose
height_map.each_with_index do |row, row_index|
  row.each_with_index do |num, column_index|
    adjacents = get_adjacent_values(row, row_index, columns, column_index) << num
    next unless adjacents.compact.sort[0] == num && adjacents.count(num) == 1
    risk_index += (num + 1)
  end
end
p risk_index

# part 2

new_height_map = File.read('advent9.txt').split.map { |row| row.chars.map { |chr| chr == "9" ? nil : chr.to_i }}
contiguous_indexes = []
new_height_map.each_with_index do |row, row_index|
  row.each_with_index do |num, column_index|
    if num
      point = [row_index, column_index]
      contiguous_indexes << point
    end
  end
end
basins = find_all_basins(contiguous_indexes) 
largest_basins = basins.sort_by { |basin| basin.length }.last(3) 
p largest_basins.inject(1) { |product, basin| product * basin.length }


