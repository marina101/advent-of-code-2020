class Ship
  attr_accessor :x, :y, :way_x, :way_y

  def initialize(x: 0, y: 0, way_x: 10, way_y: 1)
    @x = x
    @y = y
    @way_x = way_x
    @way_y = way_y
  end

  def move_ship(directions)
    directions.each_with_index do |line, i|
      m = /(\A[A-Z]{1})(\d+\z)/.match(line)
      command, units = m.captures
      units = units.to_i

      case command
      when 'N'
        @way_y += units
      when 'S'
        @way_y -= units
      when 'E'
        @way_x += units
      when 'W'
        @way_x -= units
      when 'F'
        @x = @way_x * units + @x
        @y = @way_y * units + @y
      when 'L'
        rotate(units, command)
      when 'R'
        rotate(units, command)
      end 
    end
  end

  def rotate(degrees, direction)
    number = degrees / 90 
    if direction == 'L'
      number.times.each do |_|
        old_x = @way_x
        @way_x = @way_y * -1
        @way_y = old_x
      end
    elsif direction == 'R'
      number.times.each do |_|
        old_y = @way_y
        @way_y = @way_x * -1
        @way_x = old_y
      end
    end
  end

  def print_position
    puts "ship is at x: #{x}, y: #{y}, way_x: #{way_x}, way_y: #{way_y}"
  end

  def manhattan_distance
    @x.abs + @y.abs
  end
end

def print_result(value)
  puts "the value is: #{value}"
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  lines = input.split("\n")

  s = Ship.new
  s.move_ship(lines)
  s.print_position
  print_result(s.manhattan_distance)
end

def test_string
  "F10
N3
F7
R90
F11
"
end

process