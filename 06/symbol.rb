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

  #Could be a label in the code
  # ex: (LOOP): (this is a declaration)
  #Could be a variable 
  # ex: i=100 (this is also a declaration)
  #Could be a pointer (load in a register)
  # ex: @LOOP (These can't be translated until a delcaration is made)
  # ex: @i
  #
  # You must also write support for predefined symbols, too!
  # @type {:instruction, :data}
  def initialize name, type, address=nil, options={}
    @name = name
    @type = type
    if type == :data
      if predefined?
        @address = PREDEFINED_SYMBOLS[@name]
      else
        @address = next_address if options[:assign_address]
      end
    else
      @address = address
    end
    add_to_table!
  end
  
  def add_to_table!
    @@table.merge! :"#{self.name}" => self
  end
  
  def self.for! name, type, address=nil
    self.for name, type, address, assign_address: true
  end

  def self.for name, type, address=nil, options={}
    @@table[name.to_sym] ||
      new(name, type, address, options)
  end

  def predefined?
    PREDEFINED_SYMBOLS.keys.include? @name
  end

  def assign_address
    @address = next_address
  end

  def next_address
    @@current_address += 1
  end
end
