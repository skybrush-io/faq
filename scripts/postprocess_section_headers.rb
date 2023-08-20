#!/usr/bin/env ruby

File.foreach(ARGV[0]) do |line|
  if line.start_with?('==') and line.index(" ")
    start = line.index(" ")
    slug = line[start+1..].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    puts("[#" + slug + "]")
  end
  puts(line)
end
