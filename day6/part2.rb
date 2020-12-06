def print_result(value)
  puts "The sum of the yes questions for all groups is #{value}"
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  groups = input.split("\n\n")
  group_yes_count = []

  groups.each do |group|
    people = group.split("\n")

    chars = []
    people.each {|p| chars << p.chars}
    group_yes_count << chars.inject(&:&).length
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
ab
ab
a

b"
end

process