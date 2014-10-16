load 'note.rb'

# chord - arrangement of notes
class Chord
	attr_accessor :notes
	
	def initialize(notes)
		@notes = notes
	end

	def to_s
		c = ''
		@notes.each{|n| c += "#{n.letter} "}
		c
	end

end