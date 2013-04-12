require "shogi/cell"
require "shogi/piece"

class CellTest < Test::Unit::TestCase
  def setup
    piece = Shogi::Piece::FU.new
    @cell = Shogi::Cell.new("3", "9", piece, true)
  end

  def test_place_csa
    assert_equal("39", @cell.place_csa)
  end

  def test_place_usi
    assert_equal("3i", @cell.place_usi)
  end

  def test_piece_csa
    assert_equal("+FU", @cell.piece_csa)
    @cell.upward = false
    assert_equal("-FU", @cell.piece_csa)
  end

  def test_piece_usi
    assert_equal("P", @cell.piece_usi)
    @cell.upward = false
    assert_equal("p", @cell.piece_usi)
  end
end
