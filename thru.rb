#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

input = UniMIDI::Input.find_by_name("MPK mini").open
output = UniMIDI::Output.find_by_name("Virtual Raw MIDI").open

MIDI.using(input, output) do

  #thru_except :note

  receive :note do |message|

  	puts message.note_name if message.data[1] != 127
  	output message
 
  end

  join

end

