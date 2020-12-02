def find_pair(numbers, sum)
  values = []

  numbers.each do |first|
    numbers.reverse.each do |second|
      if (first + second) == sum
        values << first
        values << second
        break
      end
    end
    break if values.length == 2
  end

  values
end

def process(test: false, sum: 2020)
  input = test ? test_string : File.read('input.txt')
  numbers = input.split("\n").collect{|i| i.to_i}.sort  

  numbers.each do |initial|
    leftover_sum = sum - initial
    values = find_pair(numbers, leftover_sum)
    if values.length == 2
      values << initial
      puts "the numbers are #{values}. Their sum is #{values.sum} and their product is #{values.inject(:*)}"
      break
    end
  end
end

def test_string
  "1721\n979\n366\n299\n675\n1456"
end

process