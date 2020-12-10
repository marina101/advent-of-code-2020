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

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  preamble = test ? 5 : 25
  numbers = input.split("\n").map(&:to_i)

  value = find_invalid_number(numbers, preamble)
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