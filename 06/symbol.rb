class Sym
  attr_reader :name, :address, :type
  @@table = Hash.new
  @@current_address = 15

  PREDEFINED_SYMBOLS = {
    'SP'      => 0,    
    'LCL'     => 1,    
    'ARG'     => 2,    
    'THIS'    => 3,
    'THAT'    => 4,  
    'R0'      => 0,     
    'R1'      => 1,     
    'R2'      => 2,
    'R3'      => 3,    
    'R4'      => 4,     
    'R5'      => 5,     
    'R6'      => 6,
    'R7'      => 7,    
    'R8'      => 8,     
    'R9'      => 9,     
    'R10'     => 10,
    'R11'     => 11,   
    'R12'     => 12, 
    'R13'     => 13,    
    'R14'     => 14,
    'R15'     => 15,   
    'SCREEN'  => 16384, 
    'KBD'     => 245676 }

  Pending = Struct.new :name
  
  def self.for! name, address=nil
    @@table[name.to_sym] ||
      new(name, address)
  end

  def self.for name, address=nil
    @@table[name.to_sym] ||
      Pending.new(name)
  end

  def initialize name, address=nil
    @name = name
    assign_address address
    add_to_table!
  end

  private
  
  def assign_address address
    if predefined?
      @address = PREDEFINED_SYMBOLS[@name]
    elsif address
      @address = address
    else
      @address = next_address
    end
  end

  def add_to_table!
    @@table.merge! :"#{self.name}" => self
  end
  
  def predefined?
    PREDEFINED_SYMBOLS.keys.include? @name
  end

  def next_address
    @@current_address += 1
  end
end
