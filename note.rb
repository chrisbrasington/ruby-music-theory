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

  def sharp?
    return true if not letter[1].nil? and letter[1] == "\#"
    false
  end

  def flat?
    return true if not letter[1].nil? and letter[1] == 'b'
    false
  end

  def sharpen()
    if sharp? or flat?
      transpose(1)
    elsif
    @key += 1
      @letter += '\#'
    end
  end

  def flatten()
    if sharp? or flat?
      transpose(-1)
    elsif
      @key -= 1
      @letter += 'b'
    end

  end

  # transpose note
  # shift key note up or down
  def transpose(amount)
    @key += amount
    @letter = Transcribe.key_to_letter(@key)
  end

  def octave(amount)
    transpose(11*amount)
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
          11 => ['B', 'Cb']   # weird enharmonics
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
    if letter == 'B#'
      return 0
    elsif letter == 'Cb'
      return 11
    elsif letter == 'E#'
      return 5
    elsif letter == 'Fb'
      return 4
    end
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

  # search for notes in scale
  def Transcribe.search(chord)
    puts

    # C scale, circle'd by fifths
    scale = Scale.new('F', 4)
    for i in 0..6
      scale.fifths
      found = scale.notes?(chord)
      if found > chord.size/2
        puts scale
        print found, '/', chord.size, ' found'
        puts '', ''
      end
    end

    # F scale, circle'd by fourths
    scale = Scale.new('C',4)
    for i in 0..6
      scale.fourths
      found = scale.notes?(chord)
      if found > chord.size/2
        puts scale
        print found, '/', chord.size, ' found'
        puts '', ''
      end
    end
  end
end

# chord - arrangement of notes
class Chord
  attr_accessor :notes, :size

  # accepts an array of notes
  def initialize(notes)
    @notes = []
    @size = 0
    notes.each{|note|
      @notes.push(note)
      @size += 1
    }
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
    @placement = placement
    @type = "Major"
    @degree = 1

    # correct key placement
    key = Transcribe.letter_to_chromatic_placement(letter)
    key += (12*placement) if placement

    find_scale(letter)

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
    c = "#{@notes[0].letter} #{@type} scale "
    if @degree != 1
      c += "(#{get_scale_degree_name})\n"
    end
    c += "\n"
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

  def find_scale(letter)

    # tonic
    note = Note.new(48, 80, true, Time.now.getutc)
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

    if @notes.first.letter != letter

      # back up beginning of search to revisit if necessary
      start = []
      @notes.each { |n| start.push(n.dup) }

      # fifths - clockwise search
      for i in 0..6
        if @notes.first.letter != letter
          fifths
        end
      end
      # fourths - clockwise search
      if @notes.first.letter != letter
        @notes = start
        for i in 0..6
          if @notes.first.letter != letter
            fourths
          end
        end
      end
    end

    if @notes.first.letter != letter
      puts "Unable to create #{letter} scale, sorry",''
    end
  end

  # rotate scale along circle of fifths
  #   (opposite direction to circle of fourths)
  #
  # [1, 2, 3, 4]  [5, 6, 7]
  #   splits swaps to begin on the 5th
  # [5, 6, 7] [1, 2, 3, 4 (sharpens)]
  #   sharpen the 7th note
  #   (also known as the prior 4th)
  #
  # notes:
  #   zero-indexed
  #   copy beginning note to end
  #   maintains sharps as it circles clockwise
  def fifths
    shifted_notes = []

    for i in 4..6
      shifted_notes.push(@notes[i])
      shifted_notes.last.key -= 12
    end
    for i in 0..3
      shifted_notes.push(@notes[i])
    end
    shifted_notes.push(shifted_notes[0].dup)
    shifted_notes.last.key += 12

    # keep shifting near placement range (say, middle of keyboard)
    shifted_notes.each { |n| n.key+= 12 } if shifted_notes[0].key < 12*@placement

    # sharpen the 7th note
    if shifted_notes[6].flat?
      shifted_notes[6].letter = shifted_notes[6].letter[0]
      shifted_notes[6].key += 1
    else
      shifted_notes[6].letter += "\#"
      shifted_notes[6].key += 1
    end

    @notes = shifted_notes
  end

  # rotate scale along circle of fourths
  #   (opposite direction to circle of fifths)
  #
  # [1, 2, 3] [4, 5, 6, 7]
  #   splits swaps to begin on the 4th
  # [4, 5, 6, 7 (flatten)] [1, 2, 3]
  #   flattens the 4th note
  #   (also known as the prior 7th)
  #
  # notes:
  #   zero-indexed
  #   copy beginning note to end
  #   maintains flats as it circles counterclockwise
  def fourths
    shifted_notes = []

    for i in 3..6
      shifted_notes.push(@notes[i])
    end
    for i in 0..2
      shifted_notes.push(@notes[i].dup)
      shifted_notes.last.key += 12
    end
    shifted_notes.push(shifted_notes[0].dup)
    shifted_notes.last.key += 12

    # keep shifting near placement range (say, middle of keyboard)
    shifted_notes.each { |n| n.key-= 12 } if shifted_notes[0].key > 12*@placement

    # flatten the 4th note
    if shifted_notes[3].sharp?
      shifted_notes[3].letter = shifted_notes[3].letter[0]
      shifted_notes[3].key -= 1
    else
      shifted_notes[3].letter += "b"
      shifted_notes[3].key -= 1
    end

    @notes = shifted_notes
  end

  def octave (amount)
    transpose(11*amount)
  end

  # relative minor
  #   scale notes: 5,6,7,0,1,2,3,4
  def relative_minor
    minor_scale = self.dup
    major = minor_scale.notes.first.letter
    notes = []
    for i in 5..6
      notes.push(@notes[i].dup)
    end
    for i in 0..4
      notes.push(@notes[i].dup)
      notes.last.key += 12
    end
    notes.push(notes.first.dup)
    notes.last.key += 12

    # keep shifting near placement range (say, middle of keyboard)
    notes.each { |n| n.key-= 12 } if notes[0].key > 12*@placement

    minor_scale.notes = notes
    minor_scale.type = "Minor (Relative to #{major} Major)"
    minor_scale
  end

  # natural minor
  # flatten 3rd, 6, 7th notes
  def to_minor
    to_major if @type != 'Major'
    minor_scale = self.dup
    minor_scale.notes[2].flatten
    minor_scale.notes[5].flatten
    minor_scale.notes[6].flatten
    @notes = minor_scale.notes
    @type = 'Minor (Natural)'
  end

  # harmonic minor
  # flatten 3rd, 6th notes
  def to_harmonic_minor
    to_major if @type != 'Major'
    minor_scale = self.dup
    minor_scale.notes[2].flatten
    minor_scale.notes[5].flatten
    @notes = minor_scale.notes
    @type = 'Minor (Harmonic)'
  end

  # melodic minor
  # flatten 3rd note
  def to_melodic_minor
    to_major if @type != 'Major'
    minor_scale = self.dup
    minor_scale.notes[2].flatten
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
    puts notes
    @output = UniMIDI::Output.use(:first)
    MIDI.using(@output) do
      notes.each { |n|
        play n.key, 0.25
      }
    end
  end

  def play_relative_minor
    notes = relative_minor.notes
    puts notes
    @output = UniMIDI::Output.use(:first)
    MIDI.using(@output) do
      notes.each { |n|
        play n.key, 0.25
      }
    end
  end

  # return number of notes found in this scale
  def notes?(chord)
    found = false
    count = 0

    # check each note against scale
    chord.notes.each{|recorded_note|
      @notes.each{|current|
        if recorded_note.key%12 == current.key%12
          found = true
        end
      }
      # record single hit
      if found
        count += 1
        found = false
      end
    }
    count
  end
end