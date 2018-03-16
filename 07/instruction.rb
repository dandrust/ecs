class Instruction

  attr_reader :string, :segment, :index

  def initialize string
    @string = string
    resolve_instruction
  end

  def resolve_instruction
    
  end


  # Imlementation for push constant x
  def to_assembly

end
