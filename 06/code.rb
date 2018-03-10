module Code

  def to_ml
    if writable?
      resolve_address if @type == :address and @symbol.is_a? Sym::Pending
      send(:"translate_#{@type}")
    end
  end

  private

  def resolve_address
    @symbol = Sym.for! @symbol.name
    @address = @symbol.address
  end

  def translate_address
    sprintf '%016b', @address
  end

  def translate_command
    "111#{translate_comp}#{translate_dest}#{translate_jump}"
  end

  def translate_jump
    case @jump
    when 'JGT'
      '001'
    when 'JEQ'
      '011'
    when 'JGE'
      '011'
    when 'JLT'
      '100'
    when 'JNE'
      '101'
    when 'JLE'
      '110'
    when 'JMP'
      '111'
    else
      '000'
    end
  end

  def translate_dest
    case @dest
    when 'M'
      '001'
    when 'D'
      '010'
    when 'MD'
      '011'
    when 'A'
      '100'
    when 'AM'
      '101'
    when 'AD'
      '110'
    when 'AMD'
      '111'
    else
      '000'
    end
  end

  def translate_comp
    reg = get_register
    c_val = case @comp
    when '0'
      '101010'
    when '1'
      '111111'
    when '-1'
      '111010'
    when 'D'
      '001100'
    when "#{reg}"
      '110000'
    when '!D'
      '001101'
    when "!#{reg}"
      '110001'
    when '-D'
      '001111'
    when "-#{reg}"
      '110011'
    when 'D+1'
      '011111'
    when "#{reg}+1"
      '110111'
    when 'D-1'
      '001110'
    when "#{reg}-1"
      '110010'
    when "D+#{reg}"
      '000010'
    when "D-#{reg}"
      '010011'
    when "#{reg}-D"
      '000111'
    when "D&#{reg}", "#{reg}&D"
      '000000'
    when "D|#{reg}", "#{reg}|D"
      '010101'
    end
    "#{reg == 'M' ? '1' : '0'}#{c_val}"
  end

  def get_register
    @comp.include?('M') ? 'M' : 'A'
  end

end
