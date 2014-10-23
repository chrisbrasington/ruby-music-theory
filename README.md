#chord-transpose (ruby)

In the works. Input, capture, and transpose chords from midi input.

#Implemented

###Input
- concurrent midi controller and computer keyboard inputs
- debug midi input as note object

###Translation
- midi key to note object 
- midi message (could contain multiple notes) to notes array
- distinction of chords (stored notes array)

###Recording
- being/stop recording
- individual notes and chords (multiple notes) stored to notes buffer
- display letters of recording

#To-do

- storing of chord progressions
- circle of fifths voodoo
- transposition of chords
- output to midi
- (possible) scale detection
- other music theory magic