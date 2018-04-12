class Instruction::PushInstruction < Instruction
  
  def initialize *args
    @file_name, @operation, @segment, @index = *args
  end

  def to_assembly
    <<-end_code
    // Start #{operation} #{segment} #{index}
    #{resolve_address}
    @SP            // Put SP in A register
    M=M+1          // Increment SP since we have it in A
    A=M-1          // Put stack address in A register
    M=D            // Write contant to stack
    // End #{operation} #{segment} #{index}
    end_code
  end

  def resolve_address
    case segment
    when :constant
      <<-end_code
      @#{index.to_i} // Put contant in A register
      D=A            // Put contant in D register
      end_code
    when :pointer, :temp
      <<-end_code
      @#{Instruction::SEGMENT_SYMBOLS[segment].to_i + index.to_i} // Put contant in A register
      D=M            // Put value at that address in D
      end_code
    when :static
      <<-end_code
      @#{sanitize_file_name}.#{index}
      D=M     // Address of static var is now in D register
      end_code
    else
      <<-end_code
      @#{Instruction::SEGMENT_SYMBOLS[segment]}
      D=M            // Store base address in D 
      @#{index.to_i} // Put index in A register
      A=D+A          // Add index to base address, store in D
      D=M
      end_code
    end
  end

end
