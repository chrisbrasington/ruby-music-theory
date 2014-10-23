load 'chord.rb'


note = Note.new(48, 80, true, Time.now.getutc)
chord = Chord.new([note])

puts "\nC major chord\n\n"
print "BEGIN\t",chord, "\n"
#puts chord

for i in 1..7
  note = (note.dup)
  if(i==3 or i==7)
    print "HALF  \t"
    note.transpose(1)
  else
    print "WHOLE \t"
    note.transpose(2)
  end
  chord.add_note(note)
  puts chord
end
puts

puts "Shifting through scales...","\n"

letter = chord.notes[0].letter
puts "#{letter} major chord"
puts chord, "\n"

for i in 1..7

  step = ""
  if(i==3 or i==7)
    chord.transpose(1)
    step = 'HALF'
  else
    chord.transpose(2)
    step = 'WHOLE'
  end

  letter = chord.notes[0].letter
  puts "#{letter} major chord\t\t#{step} STEP"
  puts chord, "\n"
end

puts "-----------------------------","\n"

puts "Cirlce of fifths to the right...", "\n"

letter = chord.notes[0].letter
puts "#{letter} major chord"
puts chord, "\n"

for i in 1..12

  fifth = 5
  sixth = 6

  step = ""
  if(i==3 or i==7)
    chord.transpose(1+sixth)
    step = "HALF"
  else
    chord.transpose(2+fifth)
    step = "WHOLE"
  end

  letter = chord.notes[0].letter
  puts "#{letter} major chord\t\t#{step} STEP"
  chord.fix_sharp_flats()
  puts chord
  puts
end

puts "-----------------------------", "\n"

puts "Circle of fifths to the left...", "\n"

letter = chord.notes[0].letter
puts "#{letter} major chord"
puts chord, "\n"

for i in (12).downto(1)
  fifth = 5
  sixth = 6

  step = ""
  if(i==3 or i==7)
    amount = (1+sixth)*-1
    chord.transpose(amount)
    step = 'HALF'
  else
    amount = (2+fifth)*-1
    chord.transpose(amount)
    step = 'WHOLE'
  end

  letter = chord.notes[0].letter
  puts "#{letter} major chord\t\t#{step} STEP"
  chord.fix_sharp_flats()
  puts chord, "\n"
end