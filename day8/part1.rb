def print_result(value)
  puts "the value of the accumulator the first time an instruction" \
  " is repeated is: #{value}"
end

def parse_rule(rule)
  if match = /(\A\w+)(\s)([\d\-+]+)/.match(rule)
    inst, _, offset = match.captures
    return { inst: inst, offset: offset.to_i }
  end
end

def build_instructions(rules)
  rules.map do |rule|
    parse_rule(rule)
  end
end

def execute_instructions(index: 0, instructions:, prev_acc: 0)
  data = instructions[index]
  return prev_acc if !!data[:acc]
  if data[:inst] == 'nop'
    data[:acc] = prev_acc
    execute_instructions(
      index: (index + 1),
      instructions: instructions,
      prev_acc: data[:acc])
  elsif data[:inst] == 'acc'
    data[:acc] = prev_acc + data[:offset]
    execute_instructions(
      index: (index + 1),
      instructions: instructions,
      prev_acc: data[:acc])
  elsif data[:inst] == 'jmp'
    data[:acc] = prev_acc
    execute_instructions(
      index: (index + data[:offset]),
      instructions: instructions,
      prev_acc: data[:acc])
  end
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  rules = input.split("\n")
  instructions = build_instructions(rules)
  acc_value = execute_instructions(instructions: instructions)
  print_result(acc_value)
end

def test_string
  "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"
end

process