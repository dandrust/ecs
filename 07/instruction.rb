class Instruction

  attr_reader :string, :operation, :segment, :index

  def self.parse string
    resolve_instruction string.chomp.strip
  end
  
  private

  def self.resolve_instruction instruction
    regex = /^(\w*)\s*(\w*)\s*(\w*)\s*/
    parsed_instruction = instruction.match regex
    operation = parsed_instruction[1].to_sym
    segment   = parsed_instruction[2].to_sym
    index     = parsed_instruction[3]
    case operation
    when :push
      PushInstruction.new operation, segment, index
    else
      ArithmeticInstruction.new operation
    end
  end
  
  


end

require './push_instruction'
require './arithmetic_instruction'
