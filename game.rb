require_relative 'checkers_board'

class Game
  attr_reader :board

  ROWS = [nil, 7, 6, 5, 4, 3, 2, 1, 0]
  COLUMNS = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }

  def initialize
    @board = Board.new
    @board.place_red_checkers
    @board.place_black_checkers
  end

  def play
    until game_over?
      display_board
      do_move
    end
    end_game
  end

  def do_move
    puts "Select piece"
    start_square = parse_input(gets.chomp)
    puts "Where do you want to move it to?"
    end_square = parse_input(gets.chomp)

    try_slide = board[start_square].perform_slide(start_square, end_square)
    board[start_square].perform_jump(start_square, end_square) unless try_slide
  end

  def game_over?
    false
  end

  def end_game
    display_board
    puts "Somebody wins!"
  end

  def parse_input(input)
    row = ROWS[input[1].to_i]
    column = COLUMNS[input[0].to_sym]
    [row, column]
  end

  def display_board
    puts "    ________________________"
    board.grid.each_with_index do |row, i|
      print "#{ -1 * (i - 8) }  |"
      row.each_with_index do |square, j|
        if square.nil? && (i + j).odd?
          print "|||"
        elsif square.nil?
          print "   "
        else
          print "(#{square.token})"
        end
      end
      print "|\n"
    end
    puts "    ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
    puts "    a  b  c  d  e  f  g  h"
    puts ""
  end
end
