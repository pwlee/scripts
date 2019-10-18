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
  attr_reader :name, :index, :higlighted, :selected, :current
  attr_writer :higlighted

  def initialize(name, index, higlighted, selected, current)
    @name = name
    @index = index
    @higlighted = higlighted
    @selected = selected
    @current = current
  end

  def toggle_selected
    @selected = !@selected
  end

  def to_s
    output = "#{higlighted ? "->" : "  "} #{current ? "*" : " "} [#{selected ? "x" : " "}] #{name}"

    if selected
      output.red
    elsif higlighted
      output.green
    else
      output
    end
  end
end

class BranchList
  attr_reader :branches

  def initialize(branches)
    @branches = branches
  end

  def move_up
    next_index = (higlighted_index - 1) % branches.size
    mark_branch_higlighted next_index
  end

  def move_down
    next_index = (higlighted_index + 1) % branches.size
    mark_branch_higlighted next_index
  end

  def render
    branches.each { |branch| puts branch }
  end

  def toggle_curret_branch_for_deletion
    higlighted_branch.toggle_selected
  end

  def delete_selected_branches
    selected_branches.each do |branch|
      puts "git branch -D #{branch.name}"
      `git branch -D #{branch.name}`
    end
  end

  private

  def higlighted_branch
    branches.find(&:higlighted)
  end

  def higlighted_index
    higlighted_branch.index || 0
  end

  def selected_branches
    branches.select(&:selected)
  end

  def mark_branch_higlighted(index)
    branches.each { |branch| branch.higlighted = branch.index == index }
  end
end

output = `git branch`
lines  = output.split("\n")

branches = lines.each_with_index.map do |line, i|
  name = line.strip.sub("* ", "")
  current = line.include?("* ")

  Branch.new(name, i, current, false, current)
end

branch_list = BranchList.new(branches)

while true
  system "clear"
  puts "-------------------------------------------------------------------".yellow
  puts "Select a branch:".yellow
  puts "(w/s or up/down to move, a/d or left/right to mark, q/x to quit)".yellow
  puts "-------------------------------------------------------------------".yellow

  branch_list.render

  input = STDIN.getch.chomp.downcase

  case input
  when 'w' then branch_list.move_up
  when 's' then branch_list.move_down
  when 'a', 'd' then branch_list.toggle_curret_branch_for_deletion
  when 'q', 'x' then exit
  when 'e', ' '
    branch_list.delete_selected_branches
    break
  when "\e"   # ANSI escape sequence
    case STDIN.getch
    when '['  # CSI
      case STDIN.getch
      when 'A' then branch_list.move_up
      when 'B' then branch_list.move_down
      when 'C', 'D' then branch_list.toggle_curret_branch_for_deletion
      end
    end
  end
end
