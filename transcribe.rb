# static class for translation of midi keys to note values
class Transcribe
  # chromatic_scale: all possible note variations
  @@chromatic_scale =
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
  @@last_key = 0

  # last_note: last evaluated note value
  #   stored if flat/sharp key is pressed twice
  @@last_note = 'A'
  
  # get chromatic scale
  def Transcribe.get_chromatic_scale
    @@chromatic_scale
  end

  # get last key (int) played
  def Transcribe.last_key
    @@last_key
  end

  # get last note played
  def Transcribe.last_note
    @@last_note
  end

  # translate key (int) to note letter
  def Transcribe.key_to_note(note)
    value = @@chromatic_scale[(note.key+3)%12]
    if value.size != 1
      if @@last_key < note.key
        value = value[0]
      else
        value = value[1]
      end
    end
    @@last_key = note.key
    @@last_note = value
    value
  end

  def Transcribe.message_to_notes(message)
    found = false
    data = message[0][:data]
    time_stamp = message[0][:timestamp]
    data.each_with_index do|num, index| 
      if num == 144

         key = data[index+1]
         velocity = data[index+2]
         if velocity != 0
            if not found
              #puts message
              found = true
            end
            letter = @@chromatic_scale[(key+3)%12]
            if letter.size != 1
              if @@last_key < key
                letter = letter[0]
              else
                letter = letter[1]
              end
            end
            @@last_key = key
            @@last_note = letter
            print letter, ' '
         end
      end
    end
    if found
      puts 
    end


  end
end