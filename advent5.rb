line_coords = File.read('advent5.txt').gsub!(/[^0-9]/, " ").split.each_slice(4).to_a
line_coords.each { |coords| coords.map! { |coord| coord.to_i } }

# part 1 (warning: jank)

line_points = line_coords.each_with_object({}) do |coord, points|
  if coord[0] == coord[2]
    y_coords = coord[1] < coord[3] ? (coord[1]..coord[3]).to_a : (coord[3]..coord[1]).to_a
    y_coords.each do |y_coord| 
      new_coord = [coord[0], y_coord]
      points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
    end 
  elsif coord[1] == coord[3]
    x_coords = coord[0] < coord[2] ? (coord[0]..coord[2]).to_a : (coord[2]..coord[0]).to_a
    x_coords.each do |x_coord| 
      new_coord = [x_coord, coord[1]]
      points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
    end
  end
end
p line_points.select { |point, count| count > 1 }.length

# part 2

line_points = line_coords.each_with_object({}) do |coord, points|
  if coord[0] == coord[2]
    y_coords = coord[1] < coord[3] ? (coord[1]..coord[3]).to_a : (coord[3]..coord[1]).to_a
    y_coords.each do |y_coord| 
      new_coord = [coord[0], y_coord]
      points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
    end 
  elsif coord[1] == coord[3]
    x_coords = coord[0] < coord[2] ? (coord[0]..coord[2]).to_a : (coord[2]..coord[0]).to_a
    x_coords.each do |x_coord| 
      new_coord = [x_coord, coord[1]]
      points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
    end
  else
    diagonal_points = coord[0] < coord[2] ? coord[2] - coord[0] : coord[0] - coord[2]
    (0..diagonal_points).each do |index|
      x_step = coord[0] < coord[2] ? coord[0] + index : coord[0] - index
      y_step = coord[1] < coord[3] ? coord[1] + index : coord[1] - index
      new_coord = [x_step, y_step]
      points[new_coord] ? points[new_coord] += 1 : points[new_coord] = 1
    end
  end
end
p line_points.select { |point, count| count > 1 }.length