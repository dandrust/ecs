#!/usr/bin/env ruby
require './instruction'

class VmTranslator

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
    File.open @file_name.gsub("vm", "asm"), "w" do |file|
      @instructions
        .select(&:writable?)
        .each do |instr|
          file.puts instr.to_assembly
      end
    end
    self
  end

end

def main
  VmTranslator
    .new(ARGV[0])
    .parse
    .write
end

main

