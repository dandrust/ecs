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
    puts @@current_address
    puts string
    @string = sanitize string
    puts @string
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

  PendingSym = Struct.new :name
  
  def set_type
    puts "sanity check"
    puts @string
    puts @string =~ /^\(.*\)$/
    puts @string.nil?
    if @string=~ /^@/
      @type = :address
      address = @string.match(/^@(.*)$/)[1]
      if address =~ /^\d*$/
        @address = address.to_i 
      else
        @symbol = PendingSym.new address
      end
    elsif @string =~ /^\(.*\)$/
      @type = :label
      puts "it's a label! instruction counter is at #{@@current_address}"
      @symbol = Sym.for! @string.match(/^\((.*)\)$/)[1], :instruction, @@current_address
    elsif @string.nil? or @string.empty? or @string =~ /^\/\//
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
    # Eliminate leading and trailing whitespace
    # then eliminate whitespace within the line
    # split off comments that may follow the good stuff
    # and finally return the good stuff
    string
      .chomp
      .gsub(' ', '')
      .split('//')
      .shift
  end

  def next_address!
    @@current_address += 1 if writable?
  end
end
