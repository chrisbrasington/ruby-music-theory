require 'unimidi'
require 'observer'
load 'note.rb'

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
	attr_accessor :midi, :midiThread, :keyboardThread

	def initialize()
		add_observer(State.new)
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
		puts "Commands: h (help), q (quit)"
		puts "Debug Midi input running.."
	end

	# continual midi input
	def midiBegin()
		@midi.open do |input|
			loop do
				note = Note.new(input.gets)
				if(note.keyDown)
				    puts note
				end
			end
		end	
	end

	# continual keyboard input
	# accepts commands
	def keyboardBegin()
		loop do
			key = gets.chomp		
			if(key == "q" or key == "quit")
				changed
				notify_observers(self)
				puts "Quitting"
				Thread.kill(@midiThread)
				exit
			elsif(key == "h" or key == "help")
				changed 
				notify_observers(self)
				menu()
			else
				puts "Unknown command"
				menu()
			end

		end
	end
end

# run
Input.new