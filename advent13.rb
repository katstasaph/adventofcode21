# input is string 

points_arr = input.split("\n").reject { |point| point.empty? }
coords = points_arr.reject { |point| point.count("a-zA-Z") > 0 }
fold_points = (points_arr - coords).map do |fold_info|
  axis = fold_info.include?("x") ? "x" : "y" # conveniently "fold along" has neither an x or a y in it
  reflect_over = fold_info[/[0-9]+/]
  [axis, reflect_over.to_i]
end
coords.map! { |coord| coord.split(",").map { |component| component.to_i } }

def fold(coords, fold_lines)
  fold_lines.each do |line|
    coords = fold_in_half(coords, line)
  end
  coords
end

def fold_in_half(coords, fold_line)
  new_points = []
  coords.each do |coord|
    new_coord = reflect_point(coord, fold_line)
	new_points.push(new_coord) unless new_points.include?(new_coord)
  end
  new_points
end

def reflect_point(coord, fold_line)
  axis = fold_line[0]
  reflect_over = fold_line[1]
  changing_index = axis == "x" ? 0 : 1
  if coord[changing_index] < reflect_over
    coord
  else
    difference = coord[changing_index] - reflect_over
	coord[changing_index] = reflect_over - difference
	coord
  end
end

def display(points)
  width = 0
  height = 0
  grid = []
  points.each do |point|
    width = point[0] if point[0] > width
    height = point[1] if point[1] > height
  end
  grid_line = (" " * (width + 1))
  (height + 1).times do |row|
    grid.push(grid_line)
  end
  points.each do |point|
    row_points = grid[point[1]].chars
	row_points[point[0]] = '@' # the most readable, to me, of the characters I tried
	grid[point[1]] = row_points.join
  end
  grid.each do |row|
    puts row
  end
end

#fold_paper = fold(coords, fold_points)
#display(fold_paper)
