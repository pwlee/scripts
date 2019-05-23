#!/usr/bin/env ruby

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

def file_name
  File.basename(__FILE__)
end

port = ARGV[0]
skip_list = ["Google"]

puts "Please specify a port".red         unless port
puts "Usage: ./#{file_name} 3000".yellow unless port
exit                                     unless port

output = `lsof -i tcp:#{port}`

puts "-------------------------------------------------------------------".green
puts "Processes which will be terminated:".green
puts "-------------------------------------------------------------------".green
output.split("\n").each do |line|
  line_parts = line.split
  command_id = line_parts[0]

  if skip_list.include? command_id
    puts line.grey + " (skipping)".grey
  else
    puts line
  end
end
puts "-------------------------------------------------------------------".green

print "Continue? (y/n): ".yellow

continue = STDIN.gets.chomp
continue = continue[0].downcase == "y"

puts "Aborting".red unless continue
exit                unless continue

# For reference, here are the column headers printed by lsof:
# COMMAND | PID | USER | FD | TYPE | DEVICE | SIZE/OFF | NODE | NAME
output.split("\n").each do |line|
  line_parts = line.split
  command_id = line_parts[0]
  process_id = line_parts[1]

  next if process_id.to_i == 0
  next if skip_list.include? command_id

  `kill -9 #{process_id}`
end
