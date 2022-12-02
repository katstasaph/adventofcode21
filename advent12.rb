def find_cave_paths(path_string)
  segments = paths_to_hash(path_string)
  return find_total_paths(segments, "start");
end

def paths_to_hash(path_string)
  path_hash = {"start" => {"neighbors" => [], "small" => false, "visitable" => false},
                       "end" => {"neighbors" => [], "small" => false, "visitable" => true}
                       };
  parsed_paths = path_string.split("\n");
  parsed_paths.each do |path|
    path_parts = path.split("-");
    path_parts.each do |part|
      if !(path_hash[part])
        path_hash[part] = {};
        path_hash[part]["small"] = part.chars.all? { |char| ('a'..'z').include?(char) }
        path_hash[part]["neighbors"] = []
        path_hash[part]["visitable"] = true
      end
    end
  end
  parsed_paths.each do |path|
     path_parts = path.split("-")
     unless (path_hash[path_parts[0]]["neighbors"].include?(path_parts[1]))
      path_hash[path_parts[0]]["neighbors"].push(path_parts[1]);
      path_hash[path_parts[1]]["neighbors"].push(path_parts[0]);      
      end
  end
  path_hash
end

# this is slow and can probably be optimized
def find_total_paths(segments, current_node, total_paths = 0, cave_totals = {"extra_chosen" => nil, "need_recheck" => false})
  segments[current_node]["neighbors"].each do |neighbor|
	if (neighbor == "end")
		total_paths += 1
		next
    end
	last_updated = cave_totals["last_updated"]
    if (cave_totals["extra_chosen"] && (cave_totals[last_updated] == 1))
	  segments[last_updated]["visitable"] = false
	end
	if cave_totals["need_recheck"]
	  cave_totals.each do |key, value| 
	    next if value == 0
	    if (segments[key] && segments[key]["small"])
	      if ((cave_totals["extra_chosen"] == key && value == 2) || value == 1)
		    segments[key]["visitable"] = false
		  end
	    end
	  end
      cave_totals["need_recheck"] = false
	end
    if (segments[neighbor]["visitable"])
	    new_segments = {}
		segments.each { |key, value| new_segments[key] = value.dup }
		if (new_segments[neighbor]["small"])
           cave_totals[neighbor] = cave_totals[neighbor] ? (cave_totals[neighbor] + 1) : 1
		   cave_totals["last_updated"] = neighbor
		   if (cave_totals[neighbor]  > 1 && !(cave_totals["extra_chosen"]))
		     cave_totals["extra_chosen"] = neighbor
			 cave_totals["need_recheck"] = true
		   end
		end
		if (!segments[neighbor]["small"] && no_more_visits?(new_segments, neighbor))
	      new_segments[neighbor]["visitable"] = false
		end
		total_paths = find_total_paths(new_segments, neighbor, total_paths, cave_totals) 
	  end
	end
  if (segments[current_node]["small"])
    cave_totals[current_node] -= 1
    if (current_node == cave_totals["extra_chosen"] && cave_totals[current_node] == 1) then cave_totals["extra_chosen"] = nil end
  end
  return total_paths
end

def no_more_visits?(segments, neighbor)
  segments[neighbor]["neighbors"].count { |neighbor| segments[neighbor]["visitable"] } < 2 # (!(segments[neighbor]["large"]) && segments[neighbor]["visitable"]) || (segments[neighbor]["large"] && 
end

#p find_cave_paths(input);