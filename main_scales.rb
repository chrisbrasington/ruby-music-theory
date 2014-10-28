require 'observer'
load 'note.rb'

puts 'fifths to the clockwise!', ''

scale = Scale.new('C', 4)
puts scale, ''

for i in 0..6
  scale.fifths
  puts scale, ''
end

puts '-----------------------'
puts 'undo, fourths to counterclockwise!', ''

for i in 0..6
  scale.fourths
  puts scale, ''
end

puts '-----------------------'
puts 'fourths to the counterclockwise!', ''

for i in 0..6
  scale.fourths
  puts scale, ''
end

puts '-----------------------'
puts 'undo, fifths to the clockwise! throw in relative minors', ''

for i in 0..6
  scale.fifths
  puts scale, ''
  puts scale.relative_minor, ''
  puts '-----------', ''
end


puts '-----------------------'
puts 'Coup de grâce: Jump to any scale from scratch', ''
scale = Scale.new('Ab',4)
scale.to_minor
puts scale
scale.play_scale