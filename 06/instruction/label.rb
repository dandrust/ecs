class Instruction::Label < Instruction
  attr_reader :symbol
  def initialize string
    @string = string
    @symbol = Sym.for! @string.match(/^\((.*)\)$/)[1], @@current_address
  end
end
