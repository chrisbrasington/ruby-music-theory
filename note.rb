load 'transcribe.rb'

# individual note
class Note
	
	# letter value, key (int) 0-120 on full piano
	# velocity and timestamp
	attr_accessor :letter, :key, :keyPress, :velocity, :timeStamp

	def initialize(current)
		@keyPress = current[0][:data][0].equal?144
		@key = current[0][:data][1]
		@velocity = current[0][:data][2]
		@timeStamp = current[0][:timestamp]
		@letter = Transcribe.keyToNote(self)
	end

	def to_s
		string = "#{letter}\t" 
		string += "key: #{key}\t\t"
		if(@keyPress)
			string += "press: down\t"
		else
			string +=  "press: up\t"
		end
		string +=  "velocity: #{velocity}\ttime: #{timeStamp}"
		string
	end

	def keyDown
		keyPress
	end

	def keyUp
		!keyPress
	end

end
