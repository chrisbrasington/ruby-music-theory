require 'unimidi'
require 'observer'
load 'note.rb'
load 'chord.rb'

# state observer
class State
	def update(input)
		clear
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
	attr_accessor :midi, :midi_thread, :keyboard_thread, :notes_buffer, :recording

	def initialize()
		add_observer(State.new)
		@recording = false

		@midi = UniMIDI::Input.first

		# midi thread for input
		@midi_thread = Thread.new {
			midi_begin
		}
		#keyboard thread for input
		@keyboard_thread = Thread.new {
			keyboard_begin
		}

		#show menu
		menu

		# loop forever until threads are killed
		while true
		end
	end

	# menu of commands
	def menu()
		#puts "Commands: c (chord record), h (help), q (quit)"
		puts "Commands: h (help), q (quit)"
		puts "Debug Midi input running.."
	end

	# continual midi input
	def midi_begin()
		@midi.open do |input|
			loop do
				# note = Note.new(input.gets)
				# if note.key_down
				#     puts note
				#     if recording
				# 		@notes_buffer.push(note)
				# 	end
				# end
				message = input.gets
				Transcribe.message_to_notes(message)
				#exit
			end
		end	
	end

	# continual keyboard input
	# accepts commands
	def keyboard_begin()
		loop do
			key = gets.chomp
			if @recording
        puts "Done Recording"
        @recording = false
        chord = Chord.new(@notes_buffer)
        puts chord
			else
        if key == "q" or key == "quit"
          changed
          notify_observers(self)
          puts "Quitting"
          exit
        elsif key == "h" or key == "help"
          changed
          notify_observers(self)
          menu
        elsif key == 'c' or key == 'chord'
          #changed
          #notify_observers(self)
          #chord_record
        else
          puts "Unknown command"
          menu
        end

			end
		end
	end

	def chord_record()
		puts "Recording..."
		@recording = true
		@notes_buffer = []
	end

end

# run
Input.new