require_relative 'checkers_pieces'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def [](square)
    x, y = square
    grid[x][y]
  end

  def []=(square, el)
    x, y = square
    grid[x][y] = el
  end

  def occupied?(square)
    return true unless self[square].nil?
    false
  end

  def occupied_by?(square, color)
    return true if self[square].color == color
  end

  def off_board?(square)
    return false if square[0].between?(0, 7) && square[1].between?(0, 7)
    true
  end

  def update_board(piece, start_square, end_square)
    self[start_square] = nil
    self[end_square] = piece
  end

  def place_black_checkers
    [0, 2].each do |row|
      place_checkers(:right, row).each do |square|
        self[square] = Piece.new(:black, square, self)
      end
    end

    place_checkers(:left, 1).each do |square|
      self[square] = Piece.new(:black, square, self)
    end
  end

  def place_red_checkers
    [5, 7].each do |row|
      place_checkers(:left, row).each do |square|
        self[square] = Piece.new(:red, square, self)
      end
    end

    place_checkers(:right, 6).each do |square|
      self[square] = Piece.new(:red, square, self)
    end
  end

  def dup
    dup_board = []
    grid.each do |row|
      dup_row = []
      row.each do |square|
        dup_row << nil if square.nil?
        dup_row << Piece.new(square.color, square.square, board.board)
      end
      dup_board << dup_row
    end
    dup_board
  end

  private

  def place_checkers(alignment, row)
    return [[row, 1], [row, 3], [row, 5], [row, 7]] if alignment == :right
    return [[row, 0], [row, 2], [row, 4], [row, 6]] if alignment == :left
  end
end
