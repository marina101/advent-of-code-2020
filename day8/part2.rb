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

def do_nop(index, instructions, prev_acc, data)
  data[:acc] = prev_acc
  execute_instructions(
    index: (index + 1),
    instructions: instructions,
    prev_acc: data[:acc])
end

def do_acc(index, instructions, prev_acc, data)
  data[:acc] = prev_acc + data[:offset]
  execute_instructions(
    index: (index + 1),
    instructions: instructions,
    prev_acc: data[:acc])
end

def do_jump(index, instructions, prev_acc, data)
  data[:acc] = prev_acc
  execute_instructions(
    index: (index + data[:offset]),
    instructions: instructions,
    prev_acc: data[:acc])
end

def execute_instructions(index: 0, instructions:, prev_acc: 0)
  if index >= instructions.length
    print_result(prev_acc)
    return index
  end
  data = instructions[index]
  return index if !!data[:acc]

  if data[:inst] == 'nop'
    do_nop(index, instructions, prev_acc, data)
  elsif data[:inst] == 'acc'
    do_acc(index, instructions, prev_acc, data)
  elsif data[:inst] == 'jmp'
    do_jump(index, instructions, prev_acc, data)
  end
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  rules = input.split("\n")
  instructions = build_instructions(rules)

  nodes_tested = []
  pointer = 0
  
  while true
    if instructions[pointer][:inst] == 'nop' && !nodes_tested.include?(pointer)
      instructions[pointer][:inst] = 'jmp'
      nodes_tested << pointer
    elsif instructions[pointer][:inst] == 'jmp' && !nodes_tested.include?(pointer)
      instructions[pointer][:inst] = 'nop'
      nodes_tested << pointer

    end
    index_at_exit = execute_instructions(instructions: instructions)
    break if index_at_exit >= instructions.length

    # Reset the instructions if it wasn't the right swap
    instructions.each {|i| i.delete(:acc)}
    if instructions[pointer][:inst] == 'nop'
      instructions[pointer][:inst] = 'jmp'
    elsif instructions[pointer][:inst] == 'jmp'
      instructions[pointer][:inst] = 'nop'
    end

    pointer += 1
  end
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