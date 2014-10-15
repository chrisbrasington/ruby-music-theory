require 'unimidi'
load 'note.rb'

input = UniMIDI::Input.first

input.open do |input|

  puts "send some MIDI to your input now..."

  loop do
    note = Note.new(input.gets)
    puts note
  end

end