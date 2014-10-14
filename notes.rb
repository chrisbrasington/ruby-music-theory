class Notes
  # notes accessor
  # little bit of weird ambiguity when say B# == C
  # may ignore typed letter values and go off midi input only
  # 12 different possible keys in an octive
  attr_accessor :notes
  
  def initialize
    @notes = Hash.new
    @notes["A"] = 0
    @notes["A#"] = 1
    @notes["Bb"] = 1
    @notes["B"] = 2
    @notes["Cb"] = 2
    @notes["C"] = 3
    #@notes["B#"] = 3 
    @notes["C#"] = 4
    @notes["Db"] = 4
    @notes["D"] = 5
    @notes["D#"] = 6
    @notes["Eb"] = 6
    @notes["E"] = 7
    @notes["Fb"] = 7
    #@notes["E#"] = 8
    @notes["F"] = 8
    @notes["F#"] = 9
    @notes["Gb"] = 9
    @notes["G"] = 10
    @notes["Ab"] = 11
    @notes["G#"] = 11
  end

  # print notes hash
  def prints
    @notes.each do |note|
      print note
    end
    puts
  end
  
  # output letter from key press
  def output(keyPress)
    keyPress %= 12
    notes.each do |key, current|
      if keyPress == current
        puts "#{key}----#{current}"
        return
      end
    end
  end

  # transpose by user typed input
  # will likely update for multiple input from midi-in
  # hit enter
  # then transpose to next midi-in hit
  def transpose
    puts "Enter note: "
    note = gets.chomp
    value = notes[note]
    found = false
    notes.each do |key, current|
      if value == current
        puts "#{key}----#{current}"
        found = true
      end
    end
    if (!found)
      puts "Not a musical note or try caps lock."
    else
      puts "Enter Transpose amount:"
      transpose = gets.chomp
      value = (value.to_i+transpose.to_i)%12

      notes.each do |key, current|
        if value == current
          puts "#{key}----#{current}"
        end
      end
    end
  end
end