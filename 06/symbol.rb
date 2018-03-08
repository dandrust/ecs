class Symz
  attr_reader :name, :address, :type

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

  @@current_address = 15
  #Could be a label in the code
  # ex: (LOOP): (this is a declaration)
  #Could be a variable 
  # ex: i=100 (this is also a declaration)
  #Could be a pointer (load in a register)
  # ex: @LOOP (These can't be translated until a delcaration is made)
  # ex: @i
  #
  # You must also write support for predefined symbols, too!
  # @type {:instruction, :memory}
  def initialize name
    @name = name
    if predefined?
      @type = :memory
      @address = PREDEFINED_KEYS[@name]
    end
  end

  def predefined?
    @name.in? PREDEFINED_SYMBOLS.keys
  end

  def assign_address
    @address = next_address
  end

  def next_address
    @@current_address += 1
  end
end
