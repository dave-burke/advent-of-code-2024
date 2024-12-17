# frozen_string_literal: true

## A direction to move
class Direction
  def initialize(name, offset_row, offset_col)
    @name = name
    @offset_row = offset_row
    @offset_col = offset_col
  end

  attr_reader :name, :offset_row, :offset_col

  def to_s
    @name
  end
end

DIRECTIONS = {
  UP: Direction.new('UP', -1, 0),
  RIGHT: Direction.new('RIGHT', 0, 1),
  DOWN: Direction.new('DOWN', 1, 0),
  LEFT: Direction.new('LEFT', 0, -1)
}.freeze

## A Point on a grid
class Point
  def initialize(row, col)
    @row = row
    @col = col
  end

  attr_reader :row, :col

  def go(direction, dist = 1)
    new_row = @row + (direction.offset_row * dist)
    new_col = @col + (direction.offset_col * dist)
    Point.new(new_row, new_col)
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
    "(#{@row},#{@col})"
  end
end

## A grid of characters (strings)
class Grid
  def initialize(rows)
    # Ensure internal rows are immutable
    @rows = rows.map(&:freeze).freeze
  end

  attr_reader :rows

  def value(point)
    @rows[point.row][point.col]
  end

  def find_first(char)
    @rows.each_with_index do |row, r|
      row.each_with_index do |col, c|
        return Point.new(r, c) if col == char
      end
    end
    nil
  end

  def scan(point, direction, &block)
    point = point.go(direction) until block.call(point)
    point
  end

  def debug
    @rows.each do |row|
      row.each do |col|
        print col
      end
      print "\n"
    end
    print "\n"
  end

  def update(&block)
    # Make a mutable copy of rows
    new_rows = @rows.map(&:dup)
    # Pass it to the caller to modify
    block.call(new_rows)
    # Return a new (frozen) grid with the user's modifications
    Grid.new(new_rows)
  end
end

## Useful with grid.update
def point_value!(rows, point, value)
  rows[point.row][point.col] = value
end
