load 'note.rb'

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

  def fix_sharp_flats()
    @notes.each{ |n|
      #puts n

      if n.letter.include?'#'
        letter = n.letter[0]

        needs_correction = false
        @notes.each{|n2|
          if n2.letter == letter or @notes[0].letter[1] == 'b'
            needs_correction = true
          end
        }

        if needs_correction
          key = (n.key+3)%12
          old = n.letter
          n.letter = Transcribe.get_chromatic_scale()[key][1]
          puts "  (correcting #{old} to #{n.letter})"
        end


      end

    }
  end

end