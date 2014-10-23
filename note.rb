require 'singleton'

# individual note
class Note
	
	# letter value, key (int) 0-120 on full piano
	# velocity and time_stamp
	attr_accessor :letter, :key, :key_press, :velocity, :time_stamp

	def initialize(key, velocity, key_press, time_stamp)
		@key = key
		@velocity = velocity
		@key_press = key_press
		@time_stamp = time_stamp

    # convert midi key to note letter
    @letter = Transcribe.key_to_letter(key)
	end

	def to_s
		string = "#{letter}\tkey: #{key}\t\t"
    @key_press ? string += "press: down\t" : string += "press: up\t"
		string +=  "velocity: #{velocity}\ttime: #{time_stamp}"
	end

	def down
		key_press
	end

	def up
		!key_press
	end

end

# static class for translation of midi keys to note values
class Transcribe
  include Singleton

  attr_accessor :chromatic_scale, :last_key, :last_note
  # chromatic_scale: all possible note variations
  @chromatic_scale =
      {
          0 => 'A',
          1 => ['A#','Bb'],
          2 => 'B',
          3 => 'C',
          4 => ['C#','Db'],
          5 => 'D',
          6 => ['D#','Eb'],
          7 => 'E' ,
          8 => 'F',
          9 => ['F#','Gb'],
          10 => 'G',
          11 => ['G#','Ab']
      }
  # last_key: used to determine if black key should be
  #   sharpened or flatted by direction of interval
  @last_key = 0

  # last_note: last evaluated note value
  #   stored if flat/sharp key is pressed twice
  @last_note = 'A'

  # get chromatic scale
  def Transcribe.get_chromatic_scale
    @chromatic_scale
  end

  # get last key (int) played
  def Transcribe.last_key
    @last_key
  end

  # get last note played
  def Transcribe.last_note
    @last_note
  end

  # translate single key (int) to note letter
  def Transcribe.key_to_letter(key)
    letter = @chromatic_scale[(key+3)%12]
    # if sharp orflat, choose which
    (@last_key < key) ? letter = letter[0] : letter = letter[1] if letter.size != 1
    @last_key = key
    @last_note = letter
    letter
  end

  # translate midi message (multiple notes) to notes array
  def Transcribe.message_to_notes(message)
    notes = []
    data = message[0][:data]
    time_stamp = message[0][:timestamp]
    data.each_with_index do|num, index|
      if num == 144
        key = data[index+1]
        velocity = data[index+2]
        if velocity != 0
          note = Note.new(key, velocity, true, time_stamp)
          notes.push(note)
        end
      end
    end
    return notes
  end
end