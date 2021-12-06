DAYS_TO_BREED = 256
INITIAL_COUNTER = 6
CHILD_COUNTER = 8

def create_fish_hash(fish)
  fish_hash = (0..CHILD_COUNTER).each_with_object({}) { |count, hsh| hsh[count] = 0 }
  fish.each { |counter| fish_hash[counter] += 1 }
  fish_hash
end

def breed_lanternfish(fish)
  days = 1 
  while days <= DAYS_TO_BREED
    next_days_fish = fish.dup
    next_days_fish[-1] = 0
    fish.each do |counter, count|
      next_days_fish[counter - 1] = count
      next_days_fish[counter] = (count - 1)
    end
    fish = next_days_fish
    if fish[-1]
      fish[INITIAL_COUNTER] += fish[-1]
      fish[CHILD_COUNTER] = fish[-1]
      fish.delete(-1)
    end
    days += 1
  end
  fish.values.inject(:+)
end

fish = File.read('advent6.txt').split(',').map { |num| num.to_i }
fish_hash = create_fish_hash(fish)

p breed_lanternfish(fish_hash)