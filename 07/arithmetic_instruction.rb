class ArithmeticInstruction < Instruction


  def initialize operation
    @operation = operation
  end

  def to_assembly
    case @operation
    # add, sub, and, or could be generalized...
    when :add
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M-1")   # Load value of SP into A register
        .push("D=M")   # load 1st val into data register
        .push("A=A-1") # subtract one from stack pointer (2nd val)
        .push("M=D+M") # write result of M+D to stack pointer
        .push("D=A+1") # increment stack pointer
        .push("@SP")
        .push("M=D")
    when :sub
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M-1")   # Load value of SP into A register
        .push("D=M")   # load 1st val into data register
        .push("A=A-1") # subtract one from stack pointer (2nd val)
        .push("M=D-M") # write result of M+D to stack pointer
        .push("D=A+1") # increment stack pointer
        .push("@SP")
        .push("M=D")
    when :and
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M-1")  # The A, D registers has the address of the stack
        .push("D=M") # put y in D reg
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("M=D&M") # write result of M+D to stack pointer
        .push("D=A+1") # increment stack pointer
        .push("@SP")
        .push("M=D")
    when :or
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M-1")  # The A, D registers has the address of the stack
        .push("D=M")
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("M=D|M") # write result of M+D to stack pointer
        .push("D=A+1") # increment stack pointer
        .push("@SP")
        .push("M=D")
    # neg and not could be generalized
    when :neg
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("AD=M")  # The A, D registers has the address of the stack
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("M=-M")  # Negate value in memory, store in memory
        .push("@SP")   # Load SP (0) into A register
        .push("M=D")   # Set SP (0) to what it was (in D register)
    when :not
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("AD=M")  # The A, D registers has the address of the stack
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("M=!M")  # Negate value in memory, store in memory
        .push("@SP")   # Load SP (0) into A register
        .push("M=D")   # Set SP (0) to what it was (in D register)
    # The remaining could be generalized
    when :eq
      # This, gt, and lt need some work with the jump business
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M-1")  # The A, D registers has the address of the stack
        .push("D=M")
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M-D") # Subtract x-y
        .push("@TRUE") # THIS IS A PROBLEM -- were taking over A then referencing M later -- uh oh.  Need to store write address to SP before jump
        .push("D;JEQ")
        .push("D=0")
        .push("M=D")
        .push("@END")
        .push("0;JMP")
        .push("(TRUE)")
        .push("D=-1") # this is FFFF -- all 1's -- true
        .push("M=D")
        .push("(END)")
        .push("@SP")
        .push("M=M+1")
    when :gt
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M")  # The A, D registers has the address of the stack
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M")
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M-D") # Subtract x-y
        .push("@TRUE")
        .push("D;JGT")
        .push("D=0")
        .push("M=D")
        .push("@END")
        .push("0;JMP")
        .push("(TRUE)")
        .push("D=-1")
        .push("M=D")
        .push("(END)")
        .push("@SP")
        .push("M=M+1")
    when :lt
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M")  # The A, D registers has the address of the stack
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M")
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M-D") # Subtract x-y
        .push("@TRUE")
        .push("D;JLT")
        .push("D=0")
        .push("M=D")
        .push("@END")
        .push("0;JMP")
        .push("(TRUE)")
        .push("D=-1")
        .push("M=D")
        .push("(END)")
        .push("@SP")
        .push("M=M+1")
    end
  end
end
