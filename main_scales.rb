require 'observer'
load 'note.rb'

@output = UniMIDI::Output.use(:first)


scale = Scale.new('C', 4)

for i in 1..8
  scale.set_degree(i)
  puts scale, ""
end
scale.play_scale

puts '------------', scale, ''
puts scale.relative_minor, ""
puts '------------'

for i in 0..11
  scale.fifths

  if scale.notes[0].key < 40
    scale.octave(1)
  end

  puts scale, ""
  puts scale.relative_minor, ""
  puts '------------'
  scale.play_scale

end

