require 'minitest/autorun'
require_relative '../lib/chess_validator'

describe ChessValidator do
  before do
    @chess_validator = ChessValidator.new
  end

  it "can create a board" do
    @chess_validator.build_board 'spec/fixture/simple_board.txt'
    board = @chess_validator.board 
    piece = board['a2']
    piece.color.must_equal 'w'
    piece.type.must_equal 'P'

    piece = board['a7']
    piece.color.must_equal 'b'
    piece.type.must_equal 'P'

    piece = board['b8']
    piece.color.must_equal 'b'
    piece.type.must_equal 'N'

    piece = board['e2']
    piece.color.must_equal 'w'
    piece.type.must_equal 'P'

    piece = board['e3']
    piece.must_be_nil
  end

  it "can process moves" do
    @chess_validator.build_board 'spec/fixture/simple_board.txt'
    expected = %w(LEGAL LEGAL ILLEGAL LEGAL LEGAL ILLEGAL ILLEGAL LEGAL LEGAL ILLEGAL LEGAL ILLEGAL)
    actual = @chess_validator.process_moves 'spec/fixture/simple_moves.txt'
    actual.must_equal expected
  end

  it "bishop cannot jump" do
    @chess_validator.build_board 'spec/fixture/simple_board.txt'
    expected = %w(ILLEGAL ILLEGAL ILLEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/bishop_moves.txt'
    actual.must_equal expected
  end

  it "bishop can kill" do
    @chess_validator.build_board 'spec/fixture/no_pawns_board.txt'
    expected = %w(LEGAL)
    actual = @chess_validator.process_moves 'spec/fixture/bishop_moves2.txt'
    actual.must_equal expected
  end

  it "king cannot jump" do
    @chess_validator.build_board 'spec/fixture/no_pawns_board.txt'
    expected = %w(ILLEGAL ILLEGAL LEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/king_moves.txt'
    actual.must_equal expected
  end

  it "king can kill" do
    @chess_validator.build_board 'spec/fixture/kill_board.txt'
    expected = %w(LEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/king_moves2.txt'
    actual.must_equal expected
  end

  it "knight can kill" do
    @chess_validator.build_board 'spec/fixture/kill_board.txt'
    expected = %w(LEGAL ILLEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/knight_moves.txt'
    actual.must_equal expected
  end

  it "queen can kill" do
    @chess_validator.build_board 'spec/fixture/kill_board.txt'
    expected = %w(LEGAL ILLEGAL LEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/queen_moves.txt'
    actual.must_equal expected
  end

  it "rook cannot jump and can kill" do
    @chess_validator.build_board 'spec/fixture/no_pawns_board.txt'
    expected = %w(ILLEGAL LEGAL LEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/rook_moves.txt'
    actual.must_equal expected
  end

  it "pawn cannot move backwards" do
    @chess_validator.build_board 'spec/fixture/kill_board.txt'
    expected = %w(ILLEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/pawn_backward_moves.txt'
    actual.must_equal expected
  end

end