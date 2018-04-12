class Instruction
  attr_reader :file_name, :operation, :segment, :index
  
  SEGMENT_SYMBOLS = {
    :local => 'LCL',
    :argument => 'ARG',
    :this => 'THIS',
    :that => 'THAT',
    :pointer => '3',
    :temp => '5'
  }

  def writable?
    !is_a?(Comment)
  end

  def base_address?
    ![:pointer, :temp].include? segment
  end

  def segment_address
    case segment
    when :constant
      index
    when :pointer, :temp
      SEGMENT_SYMBOLS[segment] + index
    else
      SEGMENT_SYMBOLS[segment]
    end
  end

  def sanitize_file_name
    file_name.match(/\.\/(\w*)\.vm/)[1]
  end

  class << self

    def parse string, translator
      @file_name = translator.file_name
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
        PushInstruction.new @file_name, operation, segment, index
      when :pop
        PopInstruction.new @file_name, operation, segment, index
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
