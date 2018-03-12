class Instruction::Address < Instruction
  attr_reader :address, :symbol

  def initialize string
    @string = string
    raw_address = @string.match(/^@(.*)$/)[1]
    if raw_address =~ /^\d*$/
      @address = raw_address.to_i 
    else
      @symbol = Sym.for address
      @address = @symbol.address unless @symbol.is_a? Sym::Pending
    end
  end
end
