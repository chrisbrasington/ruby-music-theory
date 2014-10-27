require 'unimidi'
require 'observer'
load 'note.rb'

scale = Scale.new('C', 4)

for i in 1..8
  scale.set_degree(i)
  puts scale, ""
end

puts '------------', scale, ''
puts scale.relative_minor, ""
puts '------------'

for i in 0..11
  scale.fifths

  puts scale, ""
  puts scale.relative_minor, ""
  puts '------------'
end