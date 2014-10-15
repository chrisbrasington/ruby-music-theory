require 'unimidi'
load 'note.rb'

# commands class
class Commands

	# handles uniMIDI input
	attr_accessor :input

	def initialize
		@input = UniMIDI::Input.first
		self.help
	end

	# debug stream of midi input
	#   must break out, haven't implemented non-interupt pc-keyboard input
	#   during this
	def debug
		puts 'send some MIDI to your input now...'
		puts '(must break out of)',''

		@input.open do |input|
			loop do
				note = Note.new(input.gets)
				if(note.keyDown)
				    puts note
				end
			end
		end
	end

	# chord (interval of notes) capture
	def chord
		# specify number of notes to capture
		print "Number of notes to capture: "
		n = gets.chomp
		if(is_a_number?(n) && n.to_i > 0)
			n = n.to_i
			chords = []

			# grab n number of notes
			while n > 0
				# push note into array
				note = Note.new(@input.gets)
			 	if(note.keyDown)
			 		puts note
			 		chords.push(note)
			 		n-=1
			 	end
			end

			# output captured chord
			puts '','Captured Chord:'
			chords.each{|c| print "#{c.letter} "}
			puts '',''
		else
			# try again dummy
			chord
		end
	end

	# help menu
	def help
		puts 'commands are:'
		puts '  debug, d (dumps all midi input)'
		puts '  chord, c (record a chord)'
		puts '  help,  h (this help)','  quit,  q',''
	end

	# quit handled in main loop
	# shortcuts
	def h
		help
	end
	def d
		debug
	end
	def c
		chord
	end

	def is_a_number?(s)
  		s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

end