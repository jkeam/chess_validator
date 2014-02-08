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

      if move_from && move_to
        from_piece, to_piece = @board[moves[0]], @board[moves[1]]
        valid = general_valid_move move_from, move_to, from_piece, to_piece
        if valid
          options = prepare_options moves, from_piece, to_piece
          valid = PieceUtil::validate_movement options
        end
        validity << (valid ? "LEGAL" : "ILLEGAL")
      end

    end
    validity
  end

  private 

  def general_valid_move move_from, move_to, from_piece, to_piece
    kill_move = kill_move? from_piece, to_piece
    invalid_kill_move = (from_piece && to_piece && (from_piece.color == to_piece.color))
    move_to_empty_space = from_piece && !to_piece
    movement = move_from != move_to
    (movement && (move_to_empty_space || kill_move) && !invalid_kill_move) 
  end

  def kill_move? from_piece, to_piece
    (from_piece && to_piece && (from_piece.color != to_piece.color))
  end

  def prepare_options moves, from_piece, to_piece 
    start_pos, end_pos = moves[0], moves[1]
    kill_move = kill_move? from_piece, to_piece
    start_x, start_y, end_x, end_y = PieceUtil::LETTER_TO_NUMBER[start_pos[0]], start_pos[1].to_i, PieceUtil::LETTER_TO_NUMBER[end_pos[0]], end_pos[1].to_i
    x_op = ((end_x - start_x) > 0) ? :+ : :-
    y_op = ((end_y - start_y) > 0) ? :+ : :-
    {
      board: @board,
      from_piece: from_piece, 
      to_piece: to_piece, 
      start_x: start_x,
      start_y: start_y,
      end_x: end_x,
      end_y: end_y,
      x_delta: (start_x - end_x).abs,
      y_delta: (start_y - end_y).abs,
      x_op: x_op,
      y_op: y_op,
      kill_move: kill_move 
    }
  end
end
