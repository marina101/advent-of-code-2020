class Passport
  def initialize(line)
    parse_passport(line)
  end

  def parse_passport(line)
    p_hash = {}
    pdata = line.split(/[\n ]+/)
    pdata.each do |token|
      tokens = token.split(":")
      p_hash[tokens[0].to_sym] = tokens[1]
    end
    validate_presence(p_hash)
    p_hash.each {|k,v| instance_variable_set("@#{k}",v)}
  end

  def required_data
    [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
  end

  def validate_presence(p_hash) 
    @valid = (required_data - p_hash.keys).empty? ? true : false
  end

  def valid?
    @valid
  end
end

def count_valid_passports(passports)
  count = 0
  passports.each do |p|
    count += 1 if p.valid?
  end
  count
end

def parse_passports(data)
  data.map do |line|
    Passport.new(line)
  end
end

def print_result(value)
  puts "The total number of valid passports is #{value}"
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  data = input.split("\n\n")
  passports = parse_passports(data)
  print_result(count_valid_passports(passports))
end

def test_string
  "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"
end

process