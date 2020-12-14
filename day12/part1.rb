class Ship
  attr_accessor :x, :y, :facing

  def initialize(x: 0, y: 0, facing: :east)
    @x = x
    @y = y
    @facing = facing
  end

  def move_ship(directions)
    directions.each_with_index do |line, i|
      m = /(\A[A-Z]{1})(\d+\z)/.match(line)
      command, units = m.captures
      units = units.to_i
      case command
      when 'N'
        @y += units
      when 'S'
        @y -= units
      when 'E'
        @x += units
      when 'W'
        @x -= units
      when 'F'
        if @facing == :east
          @x += units
        elsif @facing == :west
          @x -= units
        elsif @facing == :north
          @y += units
        elsif @facing == :south
          @y -= units
        end
      when 'L'
        rotate(units, command)
      when 'R'
        rotate(units, command)
      end 
    end
  end

  def rotate(degrees, direction)
    number = degrees / 90
    left_rotations = {east: :north, north: :west, west: :south, south: :east}
    right_rotations = {east: :south, south: :west, west: :north, north: :east}
    if direction == 'L'
      number.times.each {|_| @facing = left_rotations[@facing] }
    elsif direction == 'R'
      number.times.each {|_| @facing = right_rotations[@facing] }
    end
  end

  def print_position
    puts "ship is at x: #{x}, y: #{y}, facing: #{facing}"
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
R180
F11"
end

process