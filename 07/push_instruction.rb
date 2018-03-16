class PushInstruction < Instruction
  
  def to_assembly
    case segment
    when :constant
      Array.new
        .push("@#{index.to_i}") # Load the constant into the A register
        .push("D=A")            # "Compute" by passing A register value to D register
        .push("@SP")            # Load SP address to A register
        .push("M=D")            # Write M[A] = D
        .push("D=A+1")          # Increment the stack pointer
        .push("@0")
        .push("M=D")
      # Call instruction.new('whatever').to_assembly.each {|instruction| file.puts instruction }
    end
  end
end
