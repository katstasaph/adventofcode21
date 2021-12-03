# part 1

gamma = ""
epsilon = ""

numbers = File.read('advent3.txt').split.map { |number| number.chars.map { |char| char.to_i } }.transpose
numbers.each do |column|
  if column.inject(:+) > (column.length / 2)
    gamma << "1"
    epsilon << "0"
  else
    gamma << "0"
    epsilon << "1"
  end
end
p gamma.to_i(2) * epsilon.to_i(2)

# part 2

def filter_numbers(numbers, index, by_ones)
  if numbers.length == 1
    return numbers[0].join
  else
    indexed_numbers = numbers.transpose
    numbers.select! do |number|
      if indexed_numbers[index].inject(:+) >= ((numbers.length + 1)/ 2)
        by_ones ? number[index] == 1 : number[index] == 0
      else
        by_ones ? number[index] == 0 : number[index] == 1
      end
    end
  end
  filter_numbers(numbers, (index + 1), by_ones)
end

oxygen = 0
carbon_dioxide = 0

numbers = File.read('advent3.txt').split.map { |number| number.chars.map { |char| char.to_i } }
oxygen = filter_numbers(numbers.dup, 0, true)
carbon_dioxide = filter_numbers(numbers.dup, 0, false)
p oxygen.to_i(2) * carbon_dioxide.to_i(2)