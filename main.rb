require 'micromidi'
require 'observer'
load 'note.rb'

# state observer
class State
	def update(input)
		clear
		puts 'State changed.'
	end

	def clear
		system('clear') #linux
		system('cls')	#windows
	end
end

# input class
# handles concurrent midi and pc keyboard input
class Input
	include Observable
	attr_accessor :midi, :midi_thread, :keyboard_thread, :notes_buffer, :recording, :searching

	def initialize
		add_observer(State.new)

    # toggle for recording
		@recording = false

    # toggle for searching
    @searching = false

    # toggle for playback
    @playback = false

    # select midi device
    if UniMIDI::Input.all[0].nil?
      puts 'No Midi Input Devices'
    else
      @midi = UniMIDI::Input.use(:first)
    end

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
	def menu
		puts 'Commands:'
    puts 'r (record)'
    puts 's (search notes in scale)'
    puts 'p (playback recording/found notes)'
    puts 'm (midi device select)'
    puts 'h (help)'
    puts 'q (quit)'
		puts 'Debug Midi input running...'
	end

	# continual midi input
	def midi_begin
		@midi.open do |input|
			loop do
				message = input.gets
				notes = Transcribe.message_to_notes(message)

        # group together notes played at same time
        # individual notes, add a some spacing to distinguish
        print '  ' if notes.length == 1
          puts notes

        # if recording, push to notes buffer
        notes.each { |n| @notes_buffer.push(n) } if @recording
			end
		end
	end

	# continual keyboard input
	# accepts commands
	def keyboard_begin
		loop do
			key = gets.chomp

      # if recording and keyboard input
      # end recording
      if @recording or @searching
        if @recording
          puts 'Done Recording'
          @recording = false

          # create and show new chord
          chord = Chord.new(@notes_buffer)
          puts chord
        end
        if not @recording and @searching
          puts '', 'Searching...'
          @searching = false
          Transcribe.search(Chord.new(@notes_buffer))

        end
      else
        # quit
        if key == 'q' or key == 'quit'
          changed
          notify_observers(self)
          puts 'Quitting'
          Thread.kill(@midi_thread)
          exit
        # help
        elsif key == 'h' or key == 'help'
          changed
          notify_observers(self)
          menu
        # midi device select
        elsif key == 'm' or key == 'midi'
          changed
          notify_observers(self)
          @midi = UniMIDI::Input.gets
          Transcribe.set_output
        # recording mode
        elsif key == 'r' or key == 'record'
          changed
          notify_observers(self)
          chord_record
        # search mode
        elsif key == 's' or key == 'search'
          changed
          notify_observers(self)
          search
        # toggle playback
        elsif key == 'p' or key == 'play'
          changed
          notify_observers(self)
          Transcribe.play_toggle
        # unknown
        else
          puts 'Unknown command'
          menu
        end

			end
		end
	end


  # begin chord recording
	def chord_record
		puts 'Recording...'

    # flip toggle, clear notes buffer
		@recording = true
		@notes_buffer = []
  end

  # begin search
  def search
    puts 'Record notes to search:'

    # flip toggle, begin recording
    @searching = true
    chord_record
  end
end

# run
Input.new