def print_result(value)
  puts "The sum of the yes questions for all groups is #{value}"
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  data = input.split("\n\n")
  group_yes_count = []

  data.each do |line|
    group = line.split("\n")
    group_yes_count << group.join("").split("").uniq.length   
  end

  print_result(group_yes_count.sum)
end

def test_string
  "abc

a
b
c

ab
ac

a
a
a
a

b"
end

process