class ArithmeticInstruction < Instruction


  def initialize operation
    @operation = operation
  end

  def to_assembly
    case @operation
    when :add
      Array.new
        .push("@SP")   # Load address of stack pointer
        .push("A=M")   # Load value of SP into A register
        .push("A=A-1") # subtract one from stack pointer (1st val)
        .push("D=M")   # load 1st val into data register
        .push("A=A-1") # subtract one from stack pointer (2nd val)
        .push("M=D+M") # write result of M+D to stack pointer
        .push("D=A+1") # increment stack pointer
        .push("@SP")
        .push("M=D")
    when :sub
      
    when :neg
    when :eq

    when :gt
    when :lt
    when :and
    when :or
    when :not
    end
  end
end
