class Instruction::PopInstruction < Instruction
  
  def initialize *args
    @file_name, @operation, @segment, @index = *args
  end

  # TODO: Optimize for index = 0, = 1
  def to_assembly
    case segment
    when :pointer, :temp
      <<-end_code
      // Start #{operation} #{segment} #{index}
      @SP       // Point to SP
      AM=M-1    // Decrement SP, load target address in A
      D=M       // Move value to pop in D register
      @#{Instruction::SEGMENT_SYMBOLS[segment].to_i + index.to_i}   // Load destination pointer address
      M=D       // Write value to destination
      // End #{operation} #{segment} #{index}
      end_code
    when :static
      <<-end_code
      // Start #{operation} #{segment} #{index}
      @SP       // Point to SP
      AM=M-1    // Decrement SP, load target address in A
      D=M       // Move value to pop in D register
      @#{sanitize_file_name}.#{index}   // Load destination pointer address
      M=D       // Write value to destination
      // End #{operation} #{segment} #{index}
      end_code
    else
      <<-end_code
      // Start #{operation} #{segment} #{index}
      // Push segment + index to stack
      @#{Instruction::SEGMENT_SYMBOLS[segment]}
      D=M // Store base address in D 
      @#{index.to_i} // Put index in A register
      D=D+A          // Add index to base address, store in D
      @SP            // Put SP in A register
      M=M+1          // Increment SP since we have it in A
      A=M-1          // Put stack address in A register
      M=D            // Write contant to stack
      // decrement the stack pointer value by 2
      // put the value at that address in D (this is x - the value to pop)
      // write the value in D to the address at SP + 1
      @2
      D=A
      @SP
      AM=M-D
      D=M
      A=A+1
      A=M
      M=D
      // End #{operation} #{segment} #{index}
      end_code
    end
  end
  
end

