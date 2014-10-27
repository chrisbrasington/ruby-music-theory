require 'unimidi'
require 'observer'
load 'note.rb'

scale = Scale.new('C#', 4)

puts '------------', scale, ''
puts scale.relative_minor, ""
puts '------------'

for i in 0..11
  scale.fifths_clockwise

  puts scale, ""
  puts scale.relative_minor, ""
  puts '------------'
end