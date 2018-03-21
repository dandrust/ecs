class ArithmeticInstruction < Instruction

  def initialize operation
    @operation = operation
  end

  def to_assembly
    case @operation
    when :add, :sub, :and, :or
      binary_operation
    when :neg, :not
      unary_operation
    when :eq, :gt, :lt
      boolean_operation
    end
  end

  private

  def binary_operation
    "// Start #{@string}
    @SP    // Put SP in A register
    AM=M-1 // Put address of 1st argument in A, decrement SP
    D=M    // Put 1st argument in D
    @SP
    A=M-1  // Put address of 2nd argument in A
    M=D#{operation_symbol}M  // Computer, write result to M
    // End #{@string}"
  end

  def unary_operation
    "// Start #{@string}
    @SP    // Put SP in A register
    A=M-1  // Put SP value in A and D registers
    M=#{operation_symbol}M    // Computer, write result to M
    // End #{@string}"
  end

  def boolean_operation
    "// Start #{@string}
    // Decrement SP
    @SP
    AM=M-1
    // Store 1st argument
    D=M
    // Decrement SP
    @SP
    AM=M-1
    // Compute difference, store in D register
    D=M-D
    / Conditional jump
    @TRUE
    D;#{jump_condition}

    // False condition: Set D=0 for later storage
    D=0
    @END
    0;JMP

    // True condition: Set D=-1 for later storage
    (TRUE)
    D=-1 
    @END
    0;JMP

    // Wrap Up: Write result and increment SP
    (END)
    @SP
    M=M+1  // Increment SP since we have it in A
    A=M-1  // Set A to what SP was before inc.
    M=D
    // End #{@string}"
  end

  def operation_symbol
    case @operation
    when :add
      "+"
    when :sub, :neg
      "-"
    when :and
      "&"
    when :or
      "|"
    when :not
      "!"
    end
  end
  
  def jump_condition
    case @operation
    when :eq
      "JEQ"
    when :lt
      "JLT"
    when :gt
      "JGT"
    end
  end
end
