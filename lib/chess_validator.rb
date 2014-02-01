Piece = Struct.new(:color, :type)
class ChessValidator
  #setup constants
  LETTER_TO_NUMBER = Hash[('a'..'h').each_with_index.map { |l, i| [l, i+1]}] 
  NUMBER_TO_LETTER = Hash[('a'..'h').each_with_index.map { |l, i| [i+1, l]}] 
  PIECE_TO_MOVEMENT_VALIDATOR = {
    P: -> x_delta, y_delta, options do
      start_x, start_y, end_x, end_y = options[:start_x], options[:start_y], options[:end_x], options[:end_y]
      operand = (options[:color] == 'b') ? :- : :+
      valid = start_y.public_send(operand, 1) == end_y 
      valid = start_y.public_send(operand, 2) == end_y if (!valid && (start_y == 2 || start_y == 7))
      valid && (start_x == end_x)
    end,
    R: -> x_delta, y_delta, options {(x_delta == 0 && y_delta > 0) || (x_delta > 0 && y_delta == 0)},
    K: -> x_delta, y_delta, options {(x_delta < 2 && y_delta < 2)},
    B: -> x_delta, y_delta, options {(x_delta == y_delta)},
    Q: -> x_delta, y_delta, options {(x_delta == y_delta) || (x_delta == 0 && y_delta > 0) || (x_delta > 0 && y_delta == 0)},
    N: -> x_delta, y_delta, options {(x_delta == 2 && y_delta == 1) || (x_delta == 1 && y_delta == 2)}
  }
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
      valid = moves[0] == moves[1]
      from_piece, to_piece = @board[moves[0]], @board[moves[1]]
      if (!valid && from_piece && !to_piece) 
        options = prepare_options moves, from_piece
        valid = PIECE_TO_MOVEMENT_VALIDATOR[from_piece.type.to_sym].call options[:x_delta], options[:y_delta], options
      end
      validity << (valid ? "LEGAL" : "ILLEGAL")
    end
    validity
  end

  private 

  def prepare_options moves, piece
    start_pos, end_pos = moves[0], moves[1]
    start_x, start_y, end_x, end_y = LETTER_TO_NUMBER[start_pos[0]], start_pos[1].to_i, LETTER_TO_NUMBER[end_pos[0]], end_pos[1].to_i
    {
      color: piece.color,
      start_x: start_x,
      start_y: start_y,
      end_x: end_x,
      end_y: end_y,
      x_delta: (start_x - end_x).abs,
      y_delta: (start_y - end_y).abs 
    }
  end
end