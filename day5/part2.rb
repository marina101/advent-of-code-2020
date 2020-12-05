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

class Airplane
  def initialize
    @all_seats = []
    (0..127).to_a.each do |row|
      (0..7).to_a.each do |col|
        @all_seats << {row: row, col: col, id: (row * 8 + col)}
      end
    end

    @ids_of_taken_seats = []
  end

  def fill_seats(passes)
    passes.each do |pass|
      h = @all_seats.detect {|s| s[:row] == pass.row && s[:col] == pass.column}
      h[:taken] = true
      @ids_of_taken_seats << h[:id]
    end
  end

  def print_free_seats
    seats = @all_seats.select {|s| s[:taken] == nil}
    missing_seat = seats.select {|s| @ids_of_taken_seats.include?(s[:id] + 1) && @ids_of_taken_seats.include?(s[:id] - 1)}
    puts "free seats are #{missing_seat}"
  end
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  data = input.split("\n")
  
  passes = []
  data.each do |code|
    passes << BoardingPass.new(code)
  end

  a = Airplane.new
  a.fill_seats(passes)
  a.print_free_seats
end

process