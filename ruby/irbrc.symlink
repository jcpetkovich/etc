# require "irb/completion"
require 'bond'
require "irb/ext/save-history"

Bond.start

ARGV. concat [ "--readline",
               "--prompt-mode",
               "simple"]

# 25 entries in the list

IRB.conf[:SAVE_HISTORY] = 25

begin
  require 'wirble'

  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load wirble: #{err}"
end

def h (x)
  if x.is_a? Class
    query = x.name
  elsif x.is_a? String
    query = x
  end
  system('ri', '-Tf', 'ansi', query)
end


