#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'
require 'net/http'
require_relative 'aoc'

DAY = 17

LOG = Logger.new($stdout, level: Logger::DEBUG)
LOG.formatter = proc do |severity, datetime, _, msg|
  "#{datetime.strftime('%H:%M:%S')} #{severity.ljust(5)}: #{msg}\n"
end

## An intcode machine
class Machine
  def initialize(register_a, register_b, register_c, pointer)
    @register_a = register_a
    @register_b = register_b
    @register_c = register_c
    @pointer = pointer
  end

  def combo_value(operand)
    if operand >= 0 && operand <= 3
      operand
    elsif operand == 4
      register_a
    elsif operand == 5
      register_b
    elsif operand == 6
      register_c
    else
      raise "Invalid operand: #{operand}"
    end
  end

  def apply(instruction)
    raise "not implemented. got #{instruction}"
  end

  def to_s
    "A=#{@register_a}, B=#{@register_b}, C=#{@register_c}"
  end

  def inspect
    to_s
  end
end

class Instruction
  def initialize(opcode, operand)
    @opcode = opcode.to_i(3)
    @operand = operand.to_i(3)
  end

  attr_reader :opcode, :operand
end

def parse_machine(spec)
  lines = spec.split("\n")
  registers = lines.map do |line|
    _, name, value = /Register ([A-C]): (\d+)/.match(line).to_a
    [name, value]
  end.to_h
  Machine.new(registers['A'], registers['B'], registers['C'], 0)
end

def parse_program(spec)
  _, nums = spec.split(' ')
  nums.split(',')
end

def part1(input)
  machine_spec, program_spec = input.split("\n\n")
  machine = parse_machine(machine_spec)
  program = parse_program(program_spec)

  LOG.info("Machine: #{machine}")
  LOG.info("Program: #{program}")
end

def part2(input)
  LOG.warn('not implemented')
  nil if input.nil?
end

input = Aoc.download_input_if_needed(DAY)
part1(input)
