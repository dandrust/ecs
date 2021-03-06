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
        @instructions << Instruction.parse(line)
      end
    end
    self
  end

  def write
    File.open @file_name.gsub("asm", "hack"), "w" do |file|
      @instructions
        .select(&:writable?)
        .each do |instr|
          file.puts instr.to_ml
      end
    end
    self
  end

end

def main
  Assembler
    .new(ARGV[0])
    .parse
    .write
end

main

