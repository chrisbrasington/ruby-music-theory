require 'micromidi'
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

  def sharpen()
    transpose(1)
  end

  def flatten()
    transpose(-1)
  end

  # transpose note
  # shift key note up or down
  def transpose(amount)
    @key += amount
    @letter = Transcribe.key_to_letter(@key)
  end

  def flip_sharp_flat
    letter = Transcribe.get_chromatic_scale[key]
    (@letter[0] == "#") ? @letter = letter[1] : @letter = letter[0]
    true
  end

end

# static class for translation of midi keys to note values
class Transcribe
  include Singleton

  attr_accessor :chromatic_scale, :last_key, :last_note
  # chromatic_scale: all possible note variations
  @chromatic_scale =
      {
          0 => 'C',
          1 => ['C#','Db'],
          2 => 'D',
          3 => ['D#','Eb'],
          4 => 'E' ,
          5 => 'F',
          6 => ['F#','Gb'],
          7 => 'G',
          8 => ['G#','Ab'],
          9 => 'A',
          10 => ['A#','Bb'],
          11 => 'B'
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

  # give letter, returns placement in chromatic scale
  def Transcribe.letter_to_chromatic_placement(letter)
    @chromatic_scale.each{|n|
      count = n[0]
      current = n[1]
      if current.length > 1
        if current[0] == letter or current[1] == letter
          return count
        end
      elsif current == letter
        return count
      end
    }
    return false
  end

  # translate single key (int) to note letter
  def Transcribe.key_to_letter(key)
    letter = @chromatic_scale[(key)%12]
    # if sharp or flat, choose which
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

  def Transcribe.fix_sharp_flats(notes)
    notes.each{ |n|
      if n.letter.include?'#'
        letter = n.letter[0]

        needs_correction = false
        notes.each{|n2|
          if n2.letter == letter
            needs_correction = true
          end
          if n2.letter[0] == letter[0] or n2.letter[0] == letter or n2.letter == letter[0]
            needs_correction = true
          end
        }
        if needs_correction
          key = (n.key)%12
          old = n.letter
          n.letter = Transcribe.get_chromatic_scale[key][1]
        end
      end
    }
    notes
  end

  def Transcribe.degree_name(degree)
    if degree == 1
      'Tonic'
    elsif degree == 2
      'Supertonic'
    elsif degree == 3
      'Mediant'
    elsif degree == 4
      'Subdominant'
    elsif degree == 5
      'Dominant'
    elsif degree == 6
      'Submediant'
    elsif degree == 7
      'Subtonic'
    end
  end
end

# chord - arrangement of notes
class Chord
  attr_accessor :notes

  # accepts an array of notes
  def initialize(notes)
    @notes = []
    notes.each{|note| @notes.push(note)}
  end

  def to_s
    c = ''
    @notes.each{|n| c += "#{n.letter} "}
    c
  end

  def add_note(note)
    @notes.push(note)
  end

  def transpose(amount)
    @notes.each { |n| n.transpose(amount)}
  end
end

# scale - sequence of ordered notes by a fundamental pitch
class Scale
  attr_accessor :notes, :type, :degree

  # initialize based upon letter and placement on keyboard
  def initialize letter, placement

    # correct key placement
    key = Transcribe.letter_to_chromatic_placement(letter)
    key += (12*placement) if placement

    # tonic
    note = Note.new(key, 80, true, Time.now.getutc)
    @notes = []
    @notes.push(note)

    # generate major scale of tonic
    for i in 1..7
      note = (note.dup)
      if i==3 or i==7
        note.transpose(1)
      else
        note.transpose(2)
      end
      @notes.push(note)
    end
    Transcribe.fix_sharp_flats(@notes)

    @type = "Major"
    @degree = 1
  end

  def get_scale_degree_name
    Transcribe.degree_name(@degree)
  end

  def get_scale_at_degree
    degree_notes = []

    for i in @degree-1..6
      degree_notes.push(@notes[i])
    end
    for i in 0..@degree-1
      degree_notes.push(@notes[i])
    end
    degree_notes
  end

  # to string
  def to_s
    c = "#{@notes[0].letter} #{@type} scale (#{get_scale_degree_name})\n"
    if @degree == 1
      @notes.each{|n| c += "#{n.letter} "}
      c
    else
      degree_notes = get_scale_at_degree
      degree_notes.each { |n| c += "#{n.letter} "}
      c
    end
  end

  # to string (detailed)
  def to_s_notes
    c = ''
    @notes.each{|n| c += "#{n}"}
    c
  end

  #transpose notes by amount
  def transpose(amount)
    @notes.each { |n| n.transpose(amount)}
    Transcribe.fix_sharp_flats(@notes)
  end

  # rotate scale along circle of fifths
  #   (opposite direction to circle of fourths)
  def fifths
    transpose(7)
  end

  # rotate scale along circle of fourths
  #   (opposite direction to circle of fifths)
  def fourths
    transpose(-7)
  end

  def octave (amount)
    transpose(11*amount)
  end

  # relative minor
  #   scale notes: 5,6,7,0,1,2,3,4
  def relative_minor
    minor_scale = Scale.new(@notes[5].letter,4)
    minor_scale.to_minor
    minor_scale
  end

  # natural minor
  # flatten 3rd, 6, 7th notes
  def to_minor
    minor_scale = Scale.new(@notes[0].letter,4)
    minor_scale.notes[2].flatten
    minor_scale.notes[5].flatten
    minor_scale.notes[6].flatten
    Transcribe.fix_sharp_flats(minor_scale.notes)
    @notes = minor_scale.notes
    @type = 'Minor (Natural)'
  end

  # harmonic minor
  # flatten 3rd, 6th notes
  def to_harmonic_minor
    minor_scale = Scale.new(@notes[0].letter,4)
    minor_scale.notes[2].flatten
    minor_scale.notes[5].flatten
    Transcribe.fix_sharp_flats(minor_scale.notes)
    @notes = minor_scale.notes
    @type = 'Minor (Harmonic)'
  end

  # melodic minor
  # flatten 3rd note
  def to_melodic_minor
    minor_scale = Scale.new(@notes[0].letter,4)
    # flatten 3rd, 6, 7th notes
    minor_scale.notes[2].flatten
    Transcribe.fix_sharp_flats(minor_scale.notes)
    @notes = minor_scale.notes
    @type = 'Minor (Melodic)'
  end

  def to_major
    major_scale = Scale.new(@notes[0].letter,4)
    @notes = major_scale.notes
    @type = 'Major'
  end

  def set_degree(amount)
    if amount > 7
      amount = (amount%7)
    end
    @degree = amount
  end

  def play_scale
    notes = @notes
    @output = UniMIDI::Output.use(:first)
    MIDI.using(@output) do
      notes.each { |n|
        play n.letter, 0.25
      }
    end
  end

  def play_relative_minor
    notes = relative_minor.notes
    @output = UniMIDI::Output.use(:first)
    MIDI.using(@output) do
      notes.each { |n|
        play n.letter, 0.25
      }
    end
  end

end