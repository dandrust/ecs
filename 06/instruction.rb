require './code'
class Instruction

  include Code

  attr_reader :type, :symbol, :address, :comp, :dest, :jump, :string
  # @type may be:
  #   :address
  #   :comment
  #   :command
  #   :label
  #
  # @symbol is not implemented
  #
  # @address is populated when @type is :address
  #   16-bit reference to memory address
  #   populated if @type is :command
  #
  # @comp corresponds to comp field of c-instruction
  #   7 bit value
  #   populated if @type is :command
  #
  # @dest corresponds to dest field of c-instruction
  #   3 bit value
  #   populated if @type is :command
  #
  # @jump corresponds to jump field of c-instruction
  #   3 bit value
  #   populated if @type is :command
  #
  # @string is hack-language instrution
  #   that instance represents

  def initialize string
    @string = sanitize string
    get_type
  end

  def to_s
    @string
  end

  def get_type
    # @R0, @INFINITE_LOOP
    if @string[0] == "@"
      address = @string.slice 1..-1
    # if @string[1].is_a? letter; it's a symbol
      # if address.to_i == 0 and address != "0"
      #   @type = :label
      #   @label = Sym.new address
      #   
    # # It's a number, we're dealing with a direct address
      # else
        @type = :address
        @address = address.to_i
      #end
    #elsif @string =~ /^\(.*\)$/
    
    elsif @string[0..1] == "//" or @string.empty?
      @type = :comment
    else
      @type = :command
      parse_command
      # @dest = Sym.new @dest unless is_register?
    end
  end

  def parse_command
    @string.match /^([^=]*=)?([^;]*)(;.*)?$/ do 
      @dest = $1.slice 0..-2 unless $1.nil?
      @comp = $2 unless $2.nil?
      @jump = $3.slice 1..-1 unless $3.nil?
    end
  end

  def sanitize string
    string.chomp.gsub ' ', ''
  end

  #def is_register?
  #  !@dest.nil? and @dest.size <= 3 and  @dest.split('').all? {|x| ['M', 'A', 'D'].include? x}
  #end
end
