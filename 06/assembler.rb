#!/usr/bin/env ruby
require './instruction'

class Assembler
  
  def initialize file_name
    @file_name = file_name
    @instructions = []
  end

  def parse
    File.open(@file_name, 'r') do |file|
      while line = file.gets
        @instructions << Instruction.new(line)
      end
    end
  end

  def write
    File.open @file_name.gsub("asm", "hack"), "w" do |file|
      @instructions.select{ |instr| instr.type != :comment }
                   .each do |instr|
        file.puts instr.to_ml
      end
    end
  end

end

def main
  # Do a first pass to build the symbol table
  #

  # Write it!
  asm = Assembler.new ARGV[0]
  asm.parse
  asm.write
end

main

# symbol resolution
# a symbol  might show up as a label instruction, in which a the instruciton would be type label, the string would be whatever, and @label would point to the symbol
# a symbol might also be an address, in which case the address of the instruction would point to a symbo until it's resolved.
# Class of symbol - instances point to unique symbols.
# class method of Symbol will resolve all of the symbols and assign them a value, then the you'll have to go back through instructions and resolve the address, or do it on-the-fly when writing (open up .to_ml)
