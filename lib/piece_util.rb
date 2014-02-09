module PieceUtil
  LETTER_TO_NUMBER = Hash[('a'..'h').each_with_index.map { |l, i| [l, i+1]}] 
  NUMBER_TO_LETTER = Hash[('a'..'h').each_with_index.map { |l, i| [i+1, l]}] 
  PIECE_TO_MOVEMENT_VALIDATOR = {
    P: -> x_delta, y_delta, options do
      start_x, start_y, end_x, end_y = options[:start_x], options[:start_y], options[:end_x], options[:end_y]
      piece_color = options[:from_piece].color
      operand = (piece_color == 'b') ? :- : :+
      valid = start_y.public_send(operand, 1) == end_y 
      valid = start_y.public_send(operand, 2) == end_y if (!valid && (start_y == 2 || start_y == 7))
      valid = valid && (start_x == end_x)

      unless valid
        x1 = NUMBER_TO_LETTER[options[:start_x] - 1] 
        x2 = NUMBER_TO_LETTER[options[:start_x] + 1] 
        y = options[:start_y].public_send(options[:y_op], 1) 
        kill_subject1 = options[:board][x1.to_s + y.to_s]
        kill_subject2 = options[:board][x2.to_s + y.to_s]
        if kill_subject1 || kill_subject2
          valid = (kill_subject1 && kill_subject1.color != piece_color) || 
          (kill_subject2 && kill_subject2.color != piece_color)
        end
      end
      valid
    end,
    R: -> x_delta, y_delta, options do
      valid = (x_delta == 0 && y_delta > 0) || (x_delta > 0 && y_delta == 0)
      return false unless valid

      if x_delta > 0 
        max = x_delta
        valid_move_checker = -> (options, d) do 
          x = NUMBER_TO_LETTER[options[:start_x].public_send(options[:x_op], d)] 
          y = options[:start_y]
          options[:board][x.to_s + y.to_s].nil?
        end
      else
        max = y_delta
        valid_move_checker = -> (options, d) do 
          x = NUMBER_TO_LETTER[options[:start_x]]
          y = options[:start_y].public_send(options[:y_op], d) 
          options[:board][x.to_s + y.to_s].nil?
        end
      end

      (1...max).each do |d| 
        valid = valid_move_checker.call options, d if valid
      end
      valid = options[:kill_move] if valid && !valid_move_checker.call(options, max)
      valid
    end,
    K: -> x_delta, y_delta, options {(x_delta < 2 && y_delta < 2)},
    B: -> x_delta, y_delta, options do
      valid = false
      if x_delta == y_delta
        valid = true
        valid_move_checker = -> (options, d) do
          x = NUMBER_TO_LETTER[options[:start_x].public_send(options[:x_op], d)]
          y = options[:start_y].public_send(options[:y_op], d)
          valid = options[:board][x.to_s + y.to_s].nil? if valid
        end
        (1...x_delta).each do |d| 
          valid_move_checker.call options, d
        end
        valid = options[:kill_move] if valid && !valid_move_checker.call(options, x_delta)
      end
      valid
    end,
    Q: -> x_delta, y_delta, options do
      (PIECE_TO_MOVEMENT_VALIDATOR[:R].call x_delta, y_delta, options) ||
      (PIECE_TO_MOVEMENT_VALIDATOR[:B].call x_delta, y_delta, options)
    end,
    N: -> x_delta, y_delta, options {(x_delta == 2 && y_delta == 1) || (x_delta == 1 && y_delta == 2)}
  }

  def self.valid_move? board, move_from, move_to
    from_piece, to_piece = board[move_from], board[move_to]
    valid = general_valid_move move_from, move_to, from_piece, to_piece
    if valid
      options = prepare_options move_from, move_to, from_piece, to_piece, board
      valid = PIECE_TO_MOVEMENT_VALIDATOR[options[:from_piece].type.to_sym].call options[:x_delta], options[:y_delta], options
    end
    valid
  end

  private

  def self.general_valid_move move_from, move_to, from_piece, to_piece
    kill_move = kill_move? from_piece, to_piece
    invalid_kill_move = (from_piece && to_piece && (from_piece.color == to_piece.color))
    move_to_empty_space = from_piece && !to_piece
    movement = move_from != move_to
    (movement && (move_to_empty_space || kill_move) && !invalid_kill_move) 
  end

  def self.kill_move? from_piece, to_piece
    (from_piece && to_piece && (from_piece.color != to_piece.color))
  end

  def self.prepare_options move_from, move_to, from_piece, to_piece, board
    kill_move = kill_move? from_piece, to_piece
    start_x, start_y, end_x, end_y = PieceUtil::LETTER_TO_NUMBER[move_from[0]], move_from[1].to_i, PieceUtil::LETTER_TO_NUMBER[move_to[0]], move_to[1].to_i
    x_op = ((end_x - start_x) > 0) ? :+ : :-
    y_op = ((end_y - start_y) > 0) ? :+ : :-
    {
      board: board,
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
