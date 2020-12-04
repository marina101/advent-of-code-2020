def tree_count(forest, horizontal_offset, vertical_offset)
  count = 0
  horizontal_index = 0
  forest.each_with_index do |line, i|
    next if (i % vertical_offset) != 0
    count += 1 if line[horizontal_index] == '#'
    horizontal_index += horizontal_offset
  end
  count
end

def fill_forest(forest, max_offset)
  line_length = forest.length * max_offset
  forest.map do |line|
    line * line_length
  end
end

def horizontal_offsets
  [1, 3, 5, 7, 1]
end

def vertical_offsets
  [1, 1, 1, 1, 2]
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  forest = input.split("\n")
  big_forest = fill_forest(forest, horizontal_offsets.max)
  total_trees = horizontal_offsets.each_with_index.map do |horizontal_offset, i|
    tree_count(big_forest, horizontal_offset, vertical_offsets[i])
  end

  puts "The product of the number of trees in each path is #{total_trees.inject(:*)}"
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