class Notes
  # chromaticScale: all possible note variations
  # lastKey: 0 thru 120 on full size keyboard
  #   used to determine if black key should be
  #   sharpened or flatted by direction of interval
  # lastNote: last evaulated note value
  #   stored if flat/sharp key is pressed twice
  attr_accessor :chromaticScale, :lastKey, :lastNote
  
  def initialize
    @chromaticScale =
    {
        0 => "A",
        1 => ["A#","Bb"],
        2 => "B",
        3 => "C",
        4 => ["C#","Db"],
        5 => "D",
        6 => ["D#","Eb"],
        7 => "E" ,
        8 => "F",
        9 => ["F#","Gb"],
        10 => "G",
        11 => ["G#","Ab"] 
    }
    @lastKey = 0
    @lastNote = "A"
  end

  # print chromaticScale hash
  def prints
    @chromaticScale.each do |note|
      print note
    end
    puts
  end
  
  def keyToNote(key)
    return @chromaticScale[(key[0][:data][1]+3)%12]
  end

  def keyToInt(key)
    return key[0][:data][1]
  end

  # output letter from key press
  def output(key)

    puts key

    note = keyToNote(key)
    keyPress = keyToInt(key)

    if(note.size == 1)
      puts(note)
    else
      if lastKey == keyPress
        puts(@lastNote)
      elsif lastKey < keyPress
        puts(note[0])
        @lastNote = note[0]
      else
        puts(note[1])
        @lastNote = note[1]
      end
    end
    
    @lastKey = keyPress

    return
  end

  def isKeyPressDown(note)
    return note[0][:data][0].equal?144
  end

end