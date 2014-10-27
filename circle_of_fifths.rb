load 'note.rb'


note = Note.new(48, 80, true, Time.now.getutc)
scale = Chord.new([note])

puts "\nC major scale\n\n"
print "BEGIN\t",scale, "\n"
#puts chord

for i in 1..7
  note = (note.dup)
  if i==3 or i==7
    print "HALF  \t"
    note.transpose(1)
  else
    print "WHOLE \t"
    note.transpose(2)
  end
  scale.add_note(note)
  puts scale
end
puts

puts "Shifting through scales...","\n"

letter = scale.notes[0].letter
puts "#{letter} major scale"
puts scale, "\n"

for i in 1..7

  step = ""
  if i==3 or i==7
    scale.transpose(1)
    step = 'HALF'
  else
    scale.transpose(2)
    step = 'WHOLE'
  end

  letter = scale.notes[0].letter
  puts "#{letter} major scale\t\t#{step} STEP"
  puts scale, "\n"
end

puts "-----------------------------","\n"

puts "Circle of fifths to the right...", "\n"

letter = scale.notes[0].letter
puts "#{letter} major chord"
puts scale, "\n"

for i in 1..12

  fifth = 7

  step = ""
  if i==3 or i==7
    scale.transpose(fifth)
    step = "HALF"
  else
    scale.transpose(fifth)
    step = "WHOLE"
  end

  letter = scale.notes[0].letter
  puts "#{letter} major scale\t\t#{step} STEP"
  Transcribe.fix_sharp_flats(scale.notes)
  puts scale
  puts
end

puts "-----------------------------", "\n"

puts "Circle of fifths to the left...", "\n"

letter = scale.notes[0].letter
puts "#{letter} major scale"
puts scale, "\n"

for i in (12).downto(1)
  fifth = 7

  step = ""
  if i==3 or i==7
    amount = (fifth)*-1
    scale.transpose(amount)
    step = 'HALF'
  else
    amount = (fifth)*-1
    scale.transpose(amount)
    step = 'WHOLE'
  end

  letter = scale.notes[0].letter
  puts "#{letter} major scale\t\t#{step} STEP"
  Transcribe.fix_sharp_flats(scale.notes)
  puts scale, "\n"
end