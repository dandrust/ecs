class Instruction::Comment < Instruction
  attr_reader :string
  def initialize string
    @string = string
  end
end
