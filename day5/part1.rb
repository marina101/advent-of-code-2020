class BoardingPass
  attr_reader :row, :column, :seat_id, :code

  def initialize(seat_code)
    @code = seat_code
    deduce_seat(seat_code)
  end

  def deduce_seat(code)
    rows = (0..127).to_a
    seats = (0..7).to_a

    row_code = code[0..6].split("")
    seat_code = code[7..9].split("")

    @row = bin_search(rows, row_code, "F")
    @column = bin_search(seats, seat_code, "L")
    @seat_id = @row * 8 + @column
  end

  def print_info
    puts "code is #{code}, row is #{row}, column is #{column}, seat_id is #{seat_id}"
  end

  private

  def bin_search(numbers, plane_code, low_letter)
    # Final condition
    if plane_code.length == 1
      if plane_code[0] == low_letter
        return numbers[0]
      else
        return numbers[1]
      end
    # Recursive step
    else
      middle_index = numbers.length / 2
      if plane_code[0] == low_letter
        bin_search(numbers[0..(middle_index-1)], plane_code[1..-1], low_letter)
      else
        bin_search(numbers[middle_index..-1], plane_code[1..-1], low_letter)
      end
    end
  end
end

def print_result(value)
  puts "The highest seat id on a boarding pass is #{value}"
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  data = input.split("\n")
  
  seat_ids = []
  data.each do |code|
    pass = BoardingPass.new(code)
    seat_ids << pass.seat_id
  end

  print_result(seat_ids.max)
end

def test_string
  "FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL"
end

process