require 'unimidi'
require 'observer'
load 'note.rb'
load 'chord.rb'

# state observer
class State
	def update(input)
		clear()
		puts "State changed."
	end

	def clear()
		system('clear') #linux
		system('cls')	#windows
	end
end

# input class
# handles concurrent midi and pc keyboard input
class Input
	include Observable
	attr_accessor :midi, :midiThread, :keyboardThread, :notesBuffer, :recording

	def initialize()
		add_observer(State.new)
		@recording = false

		@midi = UniMIDI::Input.gets

		# midi thread for input
		@midiThread = Thread.new {
			midiBegin()
		}
		# keyboard thread for input
		@keyboardThread = Thread.new {
			keyboardBegin()
		}

		# show menu
		menu()

		# loop forever until threads are killed
		while(true)
		end
	end

	# menu of commands
	def menu()
		puts "Commands: c (chord record), h (help), q (quit)"
		puts "Debug Midi input running.."
	end

	# continual midi input
	def midiBegin()
		@midi.open do |input|
			loop do
				note = Note.new(input.gets)
				if(note.keyDown)
				    puts note
				    if(recording)
						@notesBuffer.push(note)
					end
				end
			end
		end	
	end

	# continual keyboard input
	# accepts commands
	def keyboardBegin()
		loop do
			key = gets.chomp
			if(!@recording)	
				if(key == "q" or key == "quit")
					changed
					notify_observers(self)
					puts "Quitting"
					exit
				elsif(key == "h" or key == "help")
					changed 
					notify_observers(self)
					menu()
				elsif(key == 'c' or key == 'chord')
					changed 
					notify_observers(self)
					chordRecord()
				else
					puts "Unknown command"
					menu()
				end
			else
				puts "Done Recording"
				@recording = false
				chord = Chord.new(@notesBuffer)
				puts chord
			end
		end
	end

	def chordRecord()
		puts "Recording..."
		@recording = true
		@notesBuffer = []
	end

end

# run
Input.new