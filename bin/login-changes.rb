#!/usr/bin/env ruby

require "find"

if ARGV.length != 1 
  puts "usage: #{$0} COURSE"
  exit 1
end

COURSE = ARGV[0]

DIR = File.expand_path "~umrigar/public_html"
FILE_RE = %r{(\.umt|\.txt|\.c|\.h|\.java|\.hs|\.pl\.scm|\.rb|\.erl|README|Makefile)$}

CHANGE_FILE = File.expand_path "~/.last-login"
File.new CHANGE_FILE, "w" if !File.exist? CHANGE_FILE
last_time = File.mtime(CHANGE_FILE)

changes = []
Find.find("#{DIR}/#{COURSE}") do |f|
  if FILE_RE =~ f && File.mtime(f) > last_time
    changes.push f.sub("#{DIR}/", '') 
  end
end

if changes.length > 0
  puts "changes since your last login:"
  puts '  ' + changes.join("\n  ") + "\n"
end

File.open(CHANGE_FILE, "w")
