##ruby-music-theory
Analysis of music theory from midi controller interation. 

###Search
- record notes and search for existance in major/minor scales

###Recording
- individual notes and chords (multiple notes) stored to notes buffer

###Theory - Circle of Fifths/Fourths operations
- Traversal of circle of 4ths/5ths from any location
- Scale creation by letter name
- Minor Transform/View - Natural, Harmonic, Melodic, and Relative
- scales modes/degrees

###Input/Output
- concurrent midi controller and computer keyboard inputs
- debug midi input as note object
- can set midi I/O devices
- toggle playback of scales to midi device

###Translation
- midi key to note object 
- midi message (could contain multiple notes) to notes array
- distinction of chords (stored notes array)
- correct flat/sharp distinction from chromatic scale

###To-do

- latin names of scale modes
- storing of chord progressions
- other music theory magic
