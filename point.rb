# frozen_string_literal: true

## A direction to move
class Direction
  def initialize(name, offset_row, offset_col)
    @name = name
    @offset_row = offset_row
    @offset_col = offset_col
  end

  attr_reader :name, :offset_row, :offset_col
end

DIRECTIONS = {
  UP: Direction.new('UP', -1, 0),
  RIGHT: Direction.new('RIGHT', 0, 1),
  DOWN: Direction.new('DOWN', 1, 0),
  LEFT: Direction.new('LEFT', 0, -1)
}.freeze

## A Point on a grid
class BasePoint
  def initialize(row, col, rows)
    @row = row
    @col = col
    @rows = rows
  end

  attr_reader :row, :col

  def value
    return nil if @row.negative? || @row > @rows.length || @col.negative? || @col > @rows[0].length

    @rows.dig(@row, @col)
  end

  def go(direction)
    new_row = @row + direction.offset_row
    new_col = @col + direction.offset_col
    Point.new(new_row, new_col, @rows)
  end

  def hash
    [self.class, @row, @col].hash
  end

  def ==(other)
    eql? other
  end

  def eql?(other)
    self.class == other.class &&
      @row == other.row &&
      @col == other.col
  end

  def to_s
    "(#{@row},#{@col})=#{value}"
  end
end

def map_points(rows, &block)
  n_rows = rows.length
  n_cols = rows[0].length
  result = Array.new(n_rows)
  rows.each_with_index do |row, r|
    result[r] = Array.new(n_cols)
    row.each_with_index do |_, c|
      result[r][c] = block.call(r, c, rows)
    end
  end
  result
end
