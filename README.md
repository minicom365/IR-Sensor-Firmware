R2 IR Sensor 
==================
###(A port of the OrmerodSensorBoard)

The IR Sensor PCBA uses two IR emitter diodes and one phototransistor to sense the nozzle distance from the build plate.  The circuit is based off Dave Crocker's Mini Differential IR board, along with his firmware.

This folder contains the firmware sources, including the compiled .hex file. The firmware is compiled in Atmel Studio. The .pdp files are for doing static checking or formal verification of the firmware using Escher C++ Verifier.  

To flash the IR Sensor, we are using a Tiny Programmer and Ardiuno IDE to flash the .hex file to the MCU.  There are a couple library dependencies required to make this work.  More documentation is needed on this part.

For the schematics for the R2 variant of Dave's board, check out the R2-Electronics repo.

###Robo does not sell these boards individually!
If you want one, please check out Dave's blog here and follow the links to the appropriate store: https://miscsolutions.wordpress.com/mini-height-sensor-board/

