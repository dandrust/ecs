class Instruction
  attr_reader :operation, :segment, :index
  
  def writable?
    !is_a?(Comment)# and !is_a?(Label)
  end

  class << self

    def parse string
      resolve_instruction string.chomp.strip
    end
    
    private

    def resolve_instruction instruction
      if instruction.empty? or instruction.nil? or instruction.match /^\/\//
        return Comment.new instruction
      end
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
end

require './push_instruction'
require './arithmetic_instruction'
require './comment'
