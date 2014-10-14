class Notes
  attr_accessor :notes
  
  def initialize
    @notes = Hash.new
    @notes["A"] = 0
    @notes["A#"] = 1
    @notes["Bb"] = 1
    @notes["B"] = 2
    @notes["Cb"] = 2
    @notes["B#"] = 3 
    @notes["C"] = 3
    @notes["C#"] = 4
    @notes["Db"] = 4
    @notes["D"] = 5
    @notes["D#"] = 6
    @notes["Eb"] = 6
    @notes["E"] = 7
    @notes["Fb"] = 7
    @notes["E#"] = 8
    @notes["F"] = 8
    @notes["F#"] = 9
    @notes["Gb"] = 9
    @notes["G"] = 10
    @notes["Ab"] = 11
    @notes["G#"] = 11
  end

  def prints
    @notes.each do |note|
      print note
    end
    puts
  end
  
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