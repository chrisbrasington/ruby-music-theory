require 'unimidi'
load 'notes.rb'

input = UniMIDI::Input.first
notes = Notes.new

input.open do |input|

  puts "send some MIDI to your input now..."

  loop do
    note = input.gets

    # key press up or down
    keyPressDown = notes.isKeyPressDown(note)

    # if press down
    if(keyPressDown)
    	notes.output(note)
    end
  end

end