require './code'
require './symbol'

class Instruction

  include Code

  @@current_address = -1

  attr_reader :string
  
  def self.parse string
    instruction = new_instruction! sanitize(string)
    next_address! if instruction.writable?
    instruction
  end

  def to_s
    @string
  end

  def writable?
    !is_a?(Comment) and !is_a?(Label)
  end

  private
  
  def self.new_instruction! string
    if @string=~ /^@/
      Address.new string
    elsif @string =~ /^\(.*\)$/
      Label.new string
    elsif @string.nil? or @string.empty? or @string =~ /^\/\//
      Comment.new string
    else
      Command.new string
    end
  end

  def self.sanitize string
    string
      .chomp
      .gsub(' ', '')
      .split('//')
      .shift
  end

  def self.next_address!
    @@current_address += 1
  end
end
require './instruction/command'
require './instruction/label'
require './instruction/comment'
require './instruction/address'
