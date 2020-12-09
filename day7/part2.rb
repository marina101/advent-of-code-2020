require 'byebug'
class Bag
  attr_accessor :color, :children, :weights

  def initialize(color, children)
    @color = color
    @children = children
    @weights = []
  end

  def add_child(child)
    children << child
  end

  def print_info
    puts "#{color} bags have children: #{children}, weights: #{weights}"
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
          add_edge(data[:color], child_color, child_weight.strip.to_i)
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

  def bag_weights(node)
     node.children.flat_map do |child|
      i = node.children.index { |b| b.color == child.color }
      [node.weights[i]] + [(node.weights[i] * bag_weights(child).sum)]
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
    bags[from].weights << weight if weight
  end  
end

def print_result(value)
  puts "Number of individual bags required inside the single shiny gold bag: #{value}"
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
  root_node = graph.find_bag('shiny gold')
  print_result(graph.bag_weights(root_node).sum)
end

def test_string
  "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."
end

process