def tree_count(forest, offset)
  count = 0
  index = 0
  forest.each do |line|
    count += 1 if line[index] == '#'
    index += offset
  end
  count
end

def fill_forest(forest, offset)
  line_length = forest.length * offset
  forest.map do |line|
    line * line_length
  end
end

def process(test: false, offset: 3)
  input = test ? test_string : File.read('input.txt')
  forest = input.split("\n")
  big_forest = fill_forest(forest, offset)
  puts "The number of trees in the path is #{tree_count(big_forest, offset)}"
end

def test_string
  "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"
end

process