require './code'
require './symbol'

class Instruction

  include Code

  @@current_address = 0

  attr_reader :type, :symbol, :address, :comp, :dest, :jump, :string
  # @type may be:
  #   :address (begins with @)
  #   :comment (begins wil //)
  #   :label   (surrounded by parenthesis)
  #   :command
  #
  # @symbol is the Sym class representing a label
  #   or variable in the code. If the hack-language
  #   instruction includes a symbol, @symbol will
  #   be preset
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
    set_type
    next_address!
  end

  def to_s
    @string
  end

  def writable?
    ![:comment, :label].include? @type
  end

  private

  def set_type
    if @string=~ /^@/
      @type = :address
      address = @string.match(/^@(.*)$/)[1]
       if address =~ /^\d*$/
        @address = address.to_i
       else
        # This should only create a symbol if it's not referring to 
        # a label, but we won't know that.  Will need to implement
        # a first-pass to resolve instruction/label symbols, first
        # For now, I won't return an address here (unless it's
        # predefined) I'll still try to set it though, so that if
        # the symbols is already defined I can just add it in

        # We don't know that this is always data
        # Labels are getting set to data before the
        # label is declared an so the symbol's being
        # returned but the address is never being set
        # One solution would be to always create or 
        # overwrite a symbol when it's an instruction,
        # but that seems messy
        @symbol = Sym.for address, :data
        @address = @symbol.address
       end
    elsif @string =~ /^\(.*\)$/
      @type = :label
      @symbol = Sym.for! @string.match(/^\((.*)\)$/)[1], :instruction, @@current_address
    elsif @string[0..1] == "//" or @string.empty?
      # This isn't eliminating comments that may be on the
      # same line as a command. Should probably add that
      # functionality into def sanitize
      @type = :comment
    else
      @type = :command
      parse_command
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

  def next_address!
    @@current_address += 1 if writable?
  end
end
