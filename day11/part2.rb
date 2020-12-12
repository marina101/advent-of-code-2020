def print_result(value)
  puts "the value is: #{value}"
end

def values_to_check(row, seats, ci, ri)
  arr = []

  [[-1, -1], [-1, 0], [-1, 1], [1, 1], [1, 0], [1, -1], [0, -1], [0, 1]].each do |values|
    state = nil
    rit = ri + values[0]
    cid = ci + values[1]

    while(!seats[rit][cid].nil?)
      if seats[rit][cid] != '.'
        state = seats[rit][cid]
        break
      end
      rit = rit + values[0]
      cid = cid + values[1]
    end
    arr << state
  end

  arr.compact
end

def change_full_seat_to_empty?(row, seats, ci, ri)
  count = 0
  values_to_check(row, seats, ci, ri).each do |val|
    count += 1 if val == '#'
  end
  count >= 5 ? true : false
end

def change_empty_seat_to_full?(row, seats, ci, ri)
  flip = true
  values_to_check(row, seats, ci, ri).each do |val|
    flip = false if val == '#'
  end
  flip
end

def pad_seats(seats)
  seats = seats.unshift(Array.new(seats[0].length, nil))
  seats.push(Array.new(seats[0].length, nil))
  seats.each do |row|
    row = row.unshift(nil)
    row << nil
  end
  seats
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  lines = input.split("\n")

  simple_seats = lines.map {|l| l.split("")}
  seats = pad_seats(simple_seats)
  seats_next = seats.clone.map(&:clone)
  iteration = 1

  while true
    seats.each_with_index do |row, ri|
      row.each_with_index do |val, ci|
        if val == '.'
          seats_next[ri][ci] = '.'
        elsif val == 'L'
          seats_next[ri][ci] = '#' if change_empty_seat_to_full?(row, seats, ci, ri)
        elsif val == '#'
          seats_next[ri][ci] = 'L' if change_full_seat_to_empty?(row, seats, ci, ri)
        end 
      end
    end

    break if seats.eql?(seats_next)

    seats = seats_next
    seats_next = seats.clone.map(&:clone)
    iteration += 1
  end

  count = 0
  seats.each do |row|
    count += row.count('#')
  end

  print_result(count)
end

def test_string
  "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"
end

process