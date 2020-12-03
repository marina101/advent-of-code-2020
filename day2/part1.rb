def check_password(pwd)
  count = pwd[:word].count(pwd[:letter])
  count <= pwd[:max] && count >= pwd[:min]
end

def correct_password_count(list)
  correct_count = 0
  list.each do |line|
    tokens = line.split("\s")
    pwd = {
      letter: tokens[1],
      min: tokens[0].split("-")[0].to_i,
      max: tokens[0].split("-")[1].to_i,
      word: tokens[2]
    }
    correct_count += 1 if check_password(pwd)
  end
  correct_count
end

def process(test: false, sum: 2020)
  input = test ? test_string : File.read('input.txt')
  pwds = input.split("\n")  
  puts "The number of correct passwords is #{correct_password_count(pwds)}"
end

def test_string
  "1-3 a: abcde\n1-3 b: cdefg\n2-9 c: ccccccccc"
end

process