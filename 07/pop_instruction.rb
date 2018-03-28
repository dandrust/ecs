class Instruction::PopInstruction < Instruction
  
  def initialize *args
    @operation, @segment, @index = *args
  end

  def to_assembly
    <<-end_code
    // Start #{operation} #{segment} #{index}
    @#{Instruction::SEGMENT_SYMBOLS[segment]}
    D=#{base_address? ? 'M' : 'A' } // Store base address in D 
    @#{index.to_i} // Put index in A register
    D=D+A          // Add index to base address, store in D
    @SP            // Put SP in A register
    AM=M-1          // Put stack address in A register
    M=D            // Write contant to stack
    // End #{operation} #{segment} #{index}
    end_code
  end

end
