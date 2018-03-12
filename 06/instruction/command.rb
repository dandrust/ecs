class Instruction::Command < Instruction

  attr_reader :comp, :dest, :jump
  
  def initialize string
    @string = string
    parse_command
  end
  
  def parse_command
    @string.match /^([^=]*=)?([^;]*)(;.*)?$/ do 
      @dest = $1.slice 0..-2 unless $1.nil?
      @comp = $2 unless $2.nil?
      @jump = $3.slice 1..-1 unless $3.nil?
    end
  end

end
