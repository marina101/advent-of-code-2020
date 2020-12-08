class Bag
  attr_accessor :color, :children

  def initialize(color, children)
    @color = color
    @children = children
  end

  def add_child(child)
    children << child
  end

  def print_info
    puts "#{color} bags have children: #{children}"
  end
end

class BagGraph
  attr_accessor :bags, :count

  def initialize
    @bags = []
    @count = []
  end

  def build_nodes(rules)
    rules.each do |rule|
      data = parse_rule(rule)
      add_bag(data[:color])
    end
  end

  def build_edges(rules:, inverted: false)
    rules.each do |rule|
      data = parse_rule(rule)
      next if data[:children].empty?
      children = data[:children].split(", ") 
      children.each do |child|
        m = /(\A\d+\s)(\w+\s\w+)(\sbag.*\z)/.match(child)
        child_weight, child_color, _ = m.captures
        if inverted 
          add_edge(child_color, data[:color])
        else
          add_edge(data[:color], child_color)
        end
      end
    end
  end

  def print_graph
    bags.each {|b| b.print_info}
  end

  # Note: this can contain duplicates
  def bag_list(node)
    node.children.flat_map do |child|
      [child.color] + bag_list(child)
    end
  end

  def find_bag(color)
    bags.each do |b|
      return b if b.color == color
    end
    nil
  end

  private

  def add_bag(color, children = [])
    @bags << Bag.new(color, children)
  end

  def add_edge(start_name, end_name, weight = nil)
    from = bags.index { |b| b.color == start_name }
    to = bags.index { |b| b.color == end_name }
    bags[from].children << bags[to]
    #bags[from].weights << weight if weight
  end  
end

def print_result(value)
  puts "The total number of bags that can at some point contain a shiny gold " \
  "bag is #{value}"
end

def parse_rule(rule)
  if match = /(\A\w+\s\w+)( bags contain )(no other bags.\z)/.match(rule)
    color, _, _ = match.captures
    return { color: color, children: [] }
  elsif match = /(\A\w+\s\w+)( bags contain )(.*\.\z)/.match(rule)
    color, _, children = match.captures
    return { color: color, children: children }
  end
end

def process(test: false)
  input = test ? test_string : File.read('input.txt')
  rules = input.split("\n")
  graph = BagGraph.new
  graph.build_nodes(rules)
  graph.build_edges(rules: rules)

  inverted_graph = BagGraph.new
  inverted_graph.build_nodes(rules)
  inverted_graph.build_edges(rules: rules, inverted: true)
  root_node = inverted_graph.find_bag('shiny gold')
  print_result(inverted_graph.bag_list(root_node).uniq.count)
end

def test_string
  "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."
end

process