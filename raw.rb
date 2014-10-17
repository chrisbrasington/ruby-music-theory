require 'unimidi'

midi = UniMIDI::Input.gets

midi.open do |input|
  loop do
    puts input.gets
  end
end