require 'unimidi'
load 'notes.rb'

input = UniMIDI::Input.first
notes = Notes.new

input.open do |input|

  puts "send some MIDI to your input now..."

  loop do
    m = input.gets
    
    # key press up or down
    keyPressDown = m[0][:data][0].equal?144

    # note value for translation
    note = m[0][:data][1]+3
    
    # if press down
    if(keyPressDown)
    	puts(m)
    	# output note value
    	notes.output(note)
	end
  end

end