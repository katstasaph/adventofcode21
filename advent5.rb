line_coords = File.read('advent5.txt').gsub!(/[^0-9]/, " ").split.each_slice(4).to_a
line_coords.each { |coords| coords.map! { |coord| coord.to_i } }

def horizontal?(coords)
  coords[0] == coords[2]
end

def vertical?(coords)
  coords[1] == coords[3]
end

def point_range(point1, point2)
  point1 < point2 ? (point1..point2).to_a : (point2..point1).to_a
end

def count_unique_points(points)
  points.select { |point, count| count > 1 }.length
end

# part 1 (warning: jank)

def non_diagonal_points(line_coords)
  line_points = line_coords.each_with_object({}) do |coord, points|
    if horizontal?(coord)
      y_coords = point_range(coord[1], coord[3])
      y_coords.each do |y_coord| 
        new_coord = [coord[0], y_coord]
        points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
      end 
    elsif vertical?(coord)
      x_coords = point_range(coord[0], coord[2])
      x_coords.each do |x_coord| 
        new_coord = [x_coord, coord[1]]
        points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
      end
    end
  end
end

line_points = non_diagonal_points(line_coords)
p count_unique_points(line_points)

# part 2

diagonal_coords = line_coords.reject { |coords| horizontal?(coords) || vertical?(coords) }
diagonal_coords.each do |coord|
  diagonal_points = coord[0] < coord[2] ? coord[2] - coord[0] : coord[0] - coord[2]
  (0..diagonal_points).each do |index|
    x_step = coord[0] < coord[2] ? coord[0] + index : coord[0] - index
    y_step = coord[1] < coord[3] ? coord[1] + index : coord[1] - index
    new_coord = [x_step, y_step]
    line_points[new_coord] ? line_points[new_coord] += 1 : line_points[new_coord] = 1
  end
end
p count_unique_points(line_points)