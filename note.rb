load "transcribe.rb"

# individual note
class Note
	
	# letter value, key (int) 0-120 on full piano
	# velocity and time_stamp
	attr_accessor :letter, :key, :key_press, :velocity, :time_stamp

	def initialize(key, velocity, key_press, time_stamp)
		@key = key
		@velocity = velocity
		@key_press = key_press
		@time_stamp = time_stamp

		#@key_press = current[0][:data][0].equal?144
		#@key = current[0][:data][1]
		#@velocity = current[0][:data][2]
		#@time_stamp = current[0][:timestamp]
		#@letter = Transcribe.key_to_note(self)
	end

	def to_s
		string = "#{letter}\t" 
		string += "key: #{key}\t\t"
		if @key_press
			string += "press: down\t"
		else
			string +=  "press: up\t"
		end
		string +=  "velocity: #{velocity}\ttime: #{time_stamp}"
	end

	def key_down
		key_press
	end

	def key_up
		!key_press
	end

end
