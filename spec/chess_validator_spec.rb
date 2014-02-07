require 'minitest/autorun'
require_relative '../lib/chess_validator'

describe ChessValidator do
  before do
    @chess_validator = ChessValidator.new
    @chess_validator.build_board 'spec/fixture/simple_board.txt'
  end

  it "can create a board" do
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
    expected = %w(LEGAL LEGAL ILLEGAL LEGAL LEGAL ILLEGAL ILLEGAL LEGAL LEGAL ILLEGAL LEGAL ILLEGAL)
    actual = @chess_validator.process_moves 'spec/fixture/simple_moves.txt'
    actual.must_equal expected
  end

  it "bishop cannot jump" do
    expected = %w(ILLEGAL ILLEGAL ILLEGAL ILLEGAL) 
    actual = @chess_validator.process_moves 'spec/fixture/bishop_moves.txt'
    actual.must_equal expected
  end

end