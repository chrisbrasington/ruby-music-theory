require 'observer'
load 'note.rb'

scale = Scale.new('C', 4)

play = true
#
# puts scale, ""
# scale.to_minor
# scale.play_scale
# puts scale, ""
# scale.to_harmonic_minor
# scale.play_scale
# puts scale, ""
# scale.to_melodic_minor
# scale.play_scale
# puts scale, ""
# scale.play_scale
# scale.to_major
# puts scale, ""
#
# puts '------------', scale, ''
# puts scale.relative_minor
# puts '------------'
#
# if play
#   scale.play_scale
# end
#
# for i in 0..11
#   scale.fifths
#
#   if scale.notes[0].key < 40
#     scale.octave(1)
#   end
#
#   puts scale, ""
#   puts scale.relative_minor, ""
#   puts '------------'
#   if play
#     scale.play_scale
#   end
#
# end

scale = Scale.new('Gb', 4)
puts scale