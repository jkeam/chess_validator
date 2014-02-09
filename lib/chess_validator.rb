require_relative 'piece_util'

Piece = Struct.new(:color, :type)
class ChessValidator
  include PieceUtil
  attr_accessor :board

  def build_board filename
    board = Hash.new
    File.new(filename).each_with_index do |line, row_index|
      line.split(" ").each_with_index do |pos, col_index|
        color, type = pos[0], pos[1]
        board[NUMBER_TO_LETTER[col_index+1] + (8-row_index).to_s] = Piece.new color, type unless color == '-' || type == '-'
      end
    end
    @board = board
  end

  def process_moves filename
    validity = []
    File.new(filename).each do |line|
      moves = line.split(" ")
      move_from, move_to = moves[0], moves[1]
      validity << (PieceUtil::valid_move?(board, move_from, move_to) ? "LEGAL" : "ILLEGAL") if move_from && move_to
    end
    validity
  end
end
