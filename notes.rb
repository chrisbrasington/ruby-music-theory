# static class for translation of midi keys to note values
class Transcribe
  # chromaticScale: all possible note variations
  @@chromaticScale =
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
  # lastKey: used to determine if black key should be
  #   sharpened or flatted by direction of interval
  @@lastKey = 0

  # lastNote: last evaulated note value
  #   stored if flat/sharp key is pressed twice
  @@lastNote = "A"
  
  # get chromatic scale
  def Transcribe.getChromaticScale
    @@chromaticScale
  end

  # get last key (int) played
  def Transcribe.lastKey
    @@lastKey
  end

  # get last note played
  def Transcribe.lastNote
    @@lastNote
  end

  # translate key (int) to note letter
  def Transcribe.keyToNote(note)
    value = @@chromaticScale[note.key%12]
    if(value.size == 1)
      @@lastKey = note.key
      value
    else
      if @@lastKey == note.key
        @@lastNote
      elsif @@lastKey < note.key
        @@lastNote = value[0]
        value[0]
      else
        @lastNote = value[1]
        value[1]
      end
    end
  end
end