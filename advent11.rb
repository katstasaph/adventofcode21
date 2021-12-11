MAX_ENERGY = 9
NON_OCTOPI = [:flashes, :simultaneous]

def initialize_state(octopi)
  octopi_hash = { flashes: 0, simultaneous: -1 }
  id_counter = 1
  octopi.each_with_index do |x, x_idx|
    x.each_with_index do |y, y_idx|
      octopi_hash[id_counter] = {coords: [x_idx, y_idx], counter: y, flashed: false}
      id_counter += 1
    end
  end
  octopi_hash
end

def step!(octopi, step_num)
  octopi.values.each do |value| 
    if value.is_a?(Hash) 
      increment_counter!(value)
    end
  end
  do_flashes!(octopi, step_num)
  if first_simultaneous_flash?(octopi) then octopi[:simultaneous] = (step_num) end    
end

def first_simultaneous_flash?(octopi)
  octopi.values.all? { |value| value.is_a?(Integer) || value[:counter] == 0 } && octopi[:simultaneous] < 0 
end

def increment_counter!(octopus)
  octopus[:counter] += 1
end

def do_flashes!(octopi, step_num)
  if done_flashing?(octopi)
    reset_octopi!(octopi)
    return
  end  
  octopi.values.each do |value|
    if value.is_a?(Hash)
      if should_flash?(value) then flash!(octopi, value) end
   end
  end
  do_flashes!(octopi, step_num)
end

def done_flashing?(octopi)
  octopi.values.all? { |value| value.is_a?(Integer) || value[:counter] <= 9 || value[:flashed] }
end

def reset_octopi!(octopi)
  octopi.values.each { |value| if value.is_a?(Hash) then value[:flashed] = false end }
end

def should_flash?(octopus)
  !octopus[:flashed] && octopus[:counter] > 9
end

def flash!(octopi, octopus)
  octopus[:counter] = 0
  octopus[:flashed] = true
  octopi[:flashes] += 1  
  affected_octopi = find_adjacent_octopi(octopi, octopus)
  affected_octopi.values.each do |octopus| 
    octopus[:counter] += 1 
  end
end

def find_adjacent_octopi(octopi, octopus)
  octopi.select { |key, value| !NON_OCTOPI.include?(key) && !value[:flashed] && adjacent?(value, octopus)  }
end

def adjacent?(octopi, octopus)
  octopi[:coords] != octopus[:coords] && (octopi[:coords][0] - octopus[:coords][0]).abs <= 1 && (octopi[:coords][1] - octopus[:coords][1]).abs <= 1
end

octopi_data = File.read('advent11.txt').split.map { |line| line.chars.map { |chr| chr.to_i } }
octopi_hash = initialize_state(octopi_data)
step_num = 1
until octopi_hash[:simultaneous] > 0
  step!(octopi_hash, step_num) 
  if step_num == 100 then puts "Total flashes after 100 steps: #{octopi_hash[:flashes]}" end
  step_num += 1
end
puts "First simultaneous flash occurred on step #{octopi_hash[:simultaneous]}"