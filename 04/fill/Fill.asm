// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Set up variables
@16384
D=A
@pixelposition
M=D
@mode
M=0
@last_mode
M=0

(LISTEN)
// Set the last mode state
@mode
D=M
@last_mode
M=D
// Get keyboard input and jump to @MODE if positive
@24576
D=M
@MODE
D;JGT
// Else set @mode to zero and check reset
@mode
M=0
@RESET_PIXEL
0;JMP

(WRITE)
// THis is wrong pixel position is getting cleared.  we want pixel position to be a pointer.
@mode
D=M
@pixelposition
A=M
M=D
@INC_PIXEL
0;JMP

(INC_PIXEL)
@24575
D=A
@pixelposition
D=D-M
@LISTEN
D;JEQ
@pixelposition
D=M+1
M=D
@LISTEN
0;JMP

(RESET_PIXEL)
@last_mode
D=M
@mode
D=D-M
@WRITE
D;JEQ
@16384
D=A
@pixelposition
M=D
@WRITE
0;JMP

(MODE)
D=0
D=!D
@mode
M=D
@RESET_PIXEL
0;JMP

