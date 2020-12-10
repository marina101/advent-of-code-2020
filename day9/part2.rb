def print_result(value)
  puts "the value is: #{value}"
end

def find_invalid_number(numbers, preamble)
  numbers.each_with_index do |num, i|
    next if i < preamble
    prevs = numbers.slice(i - preamble, preamble)
    num_adds_up = false
    prevs.each_with_index do |prev_num, i|
      diff = num - prev_num
      diff_i = prevs.index {|n| n == diff}
      if prevs.include?(diff) && diff_i != i
        num_adds_up = true
      end
    end
    if !num_adds_up
      return num 
    end
    nil
  end
end

def find_num_set(value, numbers)
  numbers.each_with_index do |num, i|
    num_set = []
    while num_set.sum < value || num_set.length < 2
      num_set << numbers[i]
      i += 1
      return num_set if num_set.sum == value
    end
  end
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  preamble = test ? 5 : 25
  numbers = input.split("\n").map(&:to_i)

  invalid_number = find_invalid_number(numbers, preamble)

  num_set = find_num_set(invalid_number, numbers)
  value = num_set.min + num_set.max
  print_result(value)
end

def test_string
  "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"
end

process