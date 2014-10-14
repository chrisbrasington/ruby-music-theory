require 'unimidi'
load 'notes.rb'

input = UniMIDI::Input.first
notes = Notes.new

input.open do |input|

  $stdout.puts "send some MIDI to your input now..."

  loop do
    m = input.gets
    
    # key press up or down
    pressState = m[0][:data][0]

    # note value for translation
    note = m[0][:data][1]
    note += 3

    # if press down
    if(pressState==144)
    	
    	# output note value
    	puts(m)
    	notes.output(note)
	end
  end

end