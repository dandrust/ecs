class Instruction::PushInstruction < Instruction
  
  def initialize *args
    @operation, @segment, @index = *args
  end

  def to_assembly
    case @segment
    when :constant
      <<-end_code
      // Start #{@operation} #{@segment} #{@index}
      @#{index.to_i} // Put contant in A register
      D=A            // Put contant in D register
      @SP            // Put SP in A register
      M=M+1          // Increment SP since we have it in A
      A=M-1          // Put stack address in A register
      M=D            // Write contant to stack
      // End #{@operation} #{@segment} #{@index}
      end_code
      # Call instruction.new('whatever').to_assembly.each {|instruction| file.puts instruction }
    end
  end
end
