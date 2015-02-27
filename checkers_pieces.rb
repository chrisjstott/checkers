require_relative 'checkers_board'

class Piece
  attr_reader :color, :board, :token
  attr_accessor :square

  def initialize(color, square, board)
    @color = color
    @square = square
    @board = board
    @king = false
    @token = color == :red ? 'r' : 'b'
  end

  def king?
    @king
  end

  def king_me
    @king = true
    @token = color == :red ? 'R' : 'B'
  end

  def opponent_color
    color == :red ? :black : :red
  end

  def perform_slide(start_square, end_square)
    return false if board.occupied?(end_square) || board.off_board?(end_square)

    slide_diff = find_diff(end_square, start_square)

    if move_diffs.include?(slide_diff)
      self.square = end_square
      maybe_king
      board.update_board(self, start_square, end_square)
      return true
    else
      return false
    end
  end

  def perform_jump(start_square, end_square)
    return false if board.occupied?(end_square) || board.off_board?(end_square)

    jump_diff = find_diff(end_square, start_square)
    half_diff = [(jump_diff[0] / 2), (jump_diff[1] / 2)]
    between_square = find_diff(end_square, half_diff)

    if move_diffs.include?(half_diff) &&
       board.occupied_by?(between_square, opponent_color)
      self.square = end_square
      maybe_king
      board.update_board(self, start_square, end_square)
      board[between_square] = nil
      return true
    end

    false
  end

  def move_diffs
    return [[-1, 1], [1, 1], [-1, -1], [1, -1]] if king?
    (color == :red ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]])
  end

  def find_diff(first_arr, second_arr)
    unless first_arr.length == second_arr.length
      raise 'arrays must be of equal length'
    end

    subtracted_arr = []
    first_arr.each_index do |i|
      subtracted_arr << first_arr[i] - second_arr[i]
    end
    subtracted_arr
  end

  def maybe_king
    row = self.square[0]
    king_me if (color == :red && row == 0) || (color == :black && row == 7)
  end

  def inspect
    "#{self.token}"
  end
end
