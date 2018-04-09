class Instruction
  attr_reader :operation, :segment, :index
  
  SEGMENT_SYMBOLS = {
    :local => 'LCL',
    :argument => 'ARG',
    :this => 'THIS',
    :that => 'THAT',
    :pointer => '3',
    :temp => '5'
  }

  def writable?
    !is_a?(Comment)# and !is_a?(Label)
  end

  def base_address?
    ![:pointer, :temp].include? segment
    # local, argument, this, that
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
      when :pop
        PopInstruction.new operation, segment, index
      else
        ArithmeticInstruction.new operation
      end
    end
    
  end
end

require_relative 'push_instruction'
require_relative 'pop_instruction'
require_relative 'arithmetic_instruction'
require_relative 'comment'
