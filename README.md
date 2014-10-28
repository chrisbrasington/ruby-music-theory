#chord-transpose (ruby)

In the works. Input, capture, and transpose chords from midi input.

##Implemented

###Theory - Cirlce of Fifths/Fourths operations
- Traversal of circle of 4ths/5ths from any location
- Scale creation by letter name
- Minor Transform/View - Natural, Harmonic, Melodic, and Relative
- scales kept in defined degree
- scale modes

###Input
- concurrent midi controller and computer keyboard inputs
- debug midi input as note object

###Output
- playback scales to midi

###Translation
- midi key to note object 
- midi message (could contain multiple notes) to notes array
- distinction of chords (stored notes array)

###Recording
- being/stop recording
- individual notes and chords (multiple notes) stored to notes buffer
- display letters of recording

###To-do

- latin names of scale modes
- storing of chord progressions
- figuring out which scales chords/triads fit into
- more output to midi
- other music theory magic