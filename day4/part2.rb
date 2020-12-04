class Passport
  def initialize(line)
    parse_passport(line)
    validate_values if @fields_present
  end

  def validate_values
    required_data.each do |data|
      send("validate_#{data.to_s}")
      break unless @valid
    end
  end

  def validate_byr
    @valid = if /\A\d+\z/.match(@byr) && @byr.to_i >= 1920 && @byr.to_i <= 2002
      true
    else
      false
    end
  end

  def validate_iyr
    @valid = if /\A\d+\z/.match(@iyr) && @iyr.to_i >= 2010 && @iyr.to_i <= 2020
      true
    else
      false
    end
  end

  def validate_eyr
    @valid = if /\A\d+\z/.match(@eyr) && @eyr.to_i >= 2020 && @eyr.to_i <= 2030
      true
    else
      false
    end
  end

  def validate_hgt
    @valid = if /\A\d+cm\z/.match(@hgt) && @hgt.gsub("cm", "").to_i >= 150 && @hgt.gsub("cm", "").to_i <= 193
      true
    elsif /\A\d+in\z/.match(@hgt) && @hgt.gsub("in", "").to_i >= 59 && @hgt.gsub("in", "").to_i <= 76
      true
    else
      false
    end
  end

  def validate_hcl
    @valid = if /\A#[a-f0-9]{6}\z/.match(@hcl)
      true
    else
      false
    end
  end

  def validate_ecl
    @valid = %w(amb blu brn gry grn hzl oth).include?(@ecl)
  end

  def validate_pid
    @valid = /\A[0-9]{9}\z/.match(@pid) ? true : false
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
    @fields_present = (required_data - p_hash.keys).empty? ? true : false
  end

  def valid?
    @fields_present && @valid
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
  "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
end

process