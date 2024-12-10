#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require_relative 'aoc'

DAY = 9

## Represents a contiguous block for data for a single file
class Block
  def initialize(id, count)
    @id = id
    @count = count.to_i
  end

  attr_reader :id, :count

  def with_count(new_count)
    Block.new(@id, new_count)
  end

  def with_id(new_id)
    Block.new(new_id, @count)
  end

  def to_debug_s
    "{#{@id}x#{@count}}"
  end

  def copy
    Block.new(@id, @count)
  end

  def to_s
    return '.' * @count if @id.nil?

    @id * @count
  end
end

def parse_blocks(input)
  is_file = true
  next_id = 0
  blocks = []
  input.strip.chars.each do |char|
    if is_file
      blocks << Block.new(next_id.to_s, char)
      next_id += 1
    elsif char != '0'
      blocks << Block.new(nil, char)
    end
    is_file = !is_file
  end
  blocks
end

def fill_next(blocks)
  blocks = blocks.dup
  next_nil_i = blocks.index { |block| block.id.nil? }
  last_char_i = blocks.rindex { |block| !block.id.nil? }

  return nil if next_nil_i > last_char_i # done

  next_nil = blocks[next_nil_i]
  last_char = blocks[last_char_i]

  if next_nil.count > last_char.count
    # Can move entire end block
    blocks.delete_at(last_char_i)
    remainder = next_nil.count - last_char.count
    blocks[next_nil_i] = next_nil.with_count(remainder)
    blocks.insert(next_nil_i, last_char)
    blocks.insert(last_char_i, Block.new(nil, next_nil.count - remainder))
  else
    # Can only move part of the end block
    blocks[next_nil_i] = next_nil.with_id(last_char.id)
    blocks[last_char_i] = last_char.with_count(last_char.count - next_nil.count)
    blocks.push(Block.new(nil, next_nil.count))
  end
  blocks
end

def checksum(blocks)
  i = 0
  result = 0
  blocks.each do |block|
    if block.id.nil?
      i += 1 if block.count.positive?
      next
    end

    (0..block.count - 1).each do |_|
      result += block.id.to_i * i
      i += 1
    end
  end
  result
end

def part1(input)
  blocks = parse_blocks(input)

  # i = 0
  final = nil
  until blocks.nil?
    # p blocks.map(&:to_s).join
    next_blocks = fill_next(blocks)
    final = blocks if next_blocks.nil?
    blocks = next_blocks
    # i += 1
    # exit if i == 20
  end
  # p final.map(&:to_debug_s).join('|')
  puts checksum(final)
end

def fill_next2(blocks, id)
  blocks = blocks.dup

  block_to_move_i = blocks.rindex { |block| block.id.to_i == id }
  block_to_move = blocks[block_to_move_i]
  space_to_fill_i = blocks.index do |block|
    block.id.nil? && block.count >= block_to_move.count
  end

  return blocks if space_to_fill_i.nil?
  return blocks if block_to_move_i < space_to_fill_i

  space_to_fill = blocks[space_to_fill_i]

  remainder = space_to_fill.count - block_to_move.count
  blocks[space_to_fill_i] = space_to_fill.with_count(remainder)

  blocks.delete_at(block_to_move_i)
  blocks.insert(block_to_move_i, Block.new(nil, block_to_move.count))

  blocks.insert(space_to_fill_i, block_to_move.copy)

  blocks.reject { |block| block.count.zero? }
end

def split_nil_blocks(blocks)
  result = []
  blocks.each do |block|
    if block.id.nil?
      (0..block.count - 1).each do |_|
        result.push(Block.new(nil, 1))
      end
      next
    end

    result.push(block)
  end
  result
end

def part2(input)
  # puts input
  blocks = parse_blocks(input)

  max_block_i = blocks.rindex { |block| !block.id.nil? }
  max_id = blocks[max_block_i].id.to_i

  (0..max_id).reverse_each do |id|
    # puts 'id'
    # p blocks.map(&:to_s).join('|')
    blocks = fill_next2(blocks, id)
  end
  blocks = split_nil_blocks(blocks)
  # p blocks.map(&:to_s).join
  # p blocks.map(&:to_debug_s).join('|')
  puts checksum(blocks)
end

input = Aoc.download_input_if_needed(DAY)
part2(input)
