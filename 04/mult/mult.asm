// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Set up variables
@i
M=0
@R2
M=0
// While calculation
(LOOP)
@i
D=M
@R0
D=D-M
@END
D;JGE

// Add to sum
@R2
D=M
@R1
D=D+M
@R2
M=D

// Increment counter
@i
D=M+1
M=D

// Go to top of loop
@LOOP
0;JMP

// End
(END)
@END
0;JMP

// D is the data register
// A is the address register
  // load things to A by calling @100, @LOOP, @variable
// M will retrieve the value in memory at address in A
