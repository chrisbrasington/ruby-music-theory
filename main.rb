load 'commands.rb'

commands = Commands.new

# run main menu of commands
loop do
	command = gets.chomp
	if(command == 'quit' or command == 'q')
		break
	end
	if(Commands.method_defined?(command))
		commands.send(command)
	end
end
