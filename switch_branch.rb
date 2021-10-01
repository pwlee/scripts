#!/usr/bin/env ruby
require 'io/console'

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red;    colorize(31) end
  def green;  colorize(32) end
  def grey;   colorize(2)  end
  def yellow; colorize(33) end
  def blue;   colorize(34) end
end

class UnknownBranchError < StandardError
end

class Branch
  attr_reader :name, :index, :selected, :current
  attr_writer :selected

  def initialize(name, index, selected, current)
    @name = name
    @index = index
    @selected = selected
    @current = current
  end

  def to_s
    output = "#{selected ? "->" : "  "} #{current ? "*" : " "} [#{index}] #{name}"
    selected ? output.green : output
  end
end

class BranchList
  attr_reader :branches

  def initialize(branches)
    @branches = branches
  end

  def move_up
    next_index = (selected_index - 1) % branches.size
    mark_branch_selected next_index
  end

  def move_down
    next_index = (selected_index + 1) % branches.size
    mark_branch_selected next_index
  end

  def render
    branches.each { |branch| puts branch }
  end

  def switch_to_selected_branch
    raise UnknownBranchError unless selected_branch

    `git checkout #{selected_branch.name}`
  end

  private

  def selected_branch
    branches.find(&:selected)
  end

  def selected_index
    selected_branch.index || 0
  end

  def mark_branch_selected(index)
    branches.each { |branch| branch.selected = branch.index == index }
  end
end

output = `git branch`
lines  = output.split("\n")

branches = lines.each_with_index.map do |line, i|
  name = line.strip.sub("* ", "")
  current = line.include?("* ")

  Branch.new(name, i, current, current)
end

branch_list = BranchList.new(branches)

while true
  system "clear"
  puts "----------------------------------------------------------------------------------".yellow
  puts "Select a branch:".yellow
  puts "(w/s or up/down to move, a/d or left/right to mark, space to confirm, q/x to quit)".yellow
  puts "----------------------------------------------------------------------------------".yellow

  branch_list.render

  input = STDIN.getch.chomp.downcase

  case input
  when 'w' then branch_list.move_up
  when 's' then branch_list.move_down
  when 'q', 'x' then exit
  when 'e', ' '
    branch_list.switch_to_selected_branch
    break
  when "\e"   # ANSI escape sequence
    case STDIN.getch
    when '['  # CSI
      case STDIN.getch
      when 'A' then branch_list.move_up
      when 'B' then branch_list.move_down
      end
    end
  end
end
