require "shogi/piece"

class PieceTest < Test::Unit::TestCase
  def test_fu
    fu = Shogi::Piece::FU.new
    assert_equal("FU", fu.csa)
    assert_equal("P", fu.usi)
    assert_true(fu.move?(0, 1))
    assert_false(fu.move?(1, 0))
  end

  def test_to
    to = Shogi::Piece::TO.new
    assert_equal("TO", to.csa)
    assert_equal("+P", to.usi)
    assert_true(to.move?(0, 1))
    assert_true(to.move?(1, 0))
    assert_false(to.move?(-1, -1))
  end

  def test_ky
    ky = Shogi::Piece::KY.new
    assert_equal("KY", ky.csa)
    assert_equal("L", ky.usi)
    assert_true(ky.move?(0, 1))
    assert_true(ky.move?(0, 2))
    assert_false(ky.move?(1, 0))
    assert_false(ky.move?(0, -1))
  end

  def test_ny
    ny = Shogi::Piece::NY.new
    assert_equal("NY", ny.csa)
    assert_equal("+L", ny.usi)
    assert_ki(ny)
  end

  def test_ke
    ke = Shogi::Piece::KE.new
    assert_equal("KE", ke.csa)
    assert_equal("N", ke.usi)
    assert_true(ke.move?(-1, 2))
    assert_true(ke.move?( 1, 2))
    assert_false(ke.move?(0, 1))
    assert_false(ke.move?(0, 2))
    assert_false(ke.move?(1, 0))
    assert_false(ke.move?(0,-1))
  end

  def test_nk
    nk = Shogi::Piece::NK.new
    assert_equal("NK", nk.csa)
    assert_equal("+N", nk.usi)
    assert_ki(nk)
  end

  def test_gi
    gi = Shogi::Piece::GI.new
    assert_equal("GI", gi.csa)
    assert_equal("S", gi.usi)
    assert_true(gi.move?( -1,  1))
    assert_true(gi.move?(  0,  1))
    assert_true(gi.move?(  1,  1))
    assert_false(gi.move?(-1,  0))
    assert_false(gi.move?( 1,  0))
    assert_true(gi.move?( -1, -1))
    assert_false(gi.move?( 0, -1))
    assert_true(gi.move?(  1, -1))
  end

  def test_ng
    ng = Shogi::Piece::NG.new
    assert_equal("NG", ng.csa)
    assert_equal("+S", ng.usi)
    assert_ki(ng)
  end

  def test_ka
    ka = Shogi::Piece::KA.new
    assert_equal("KA", ka.csa)
    assert_equal("B", ka.usi)
    assert_true(ka.move?( -1,  1))
    assert_true(ka.move?( -2,  2))
    assert_false(ka.move?( 0,  1))
    assert_true(ka.move?(  1,  1))
    assert_false(ka.move?(-1,  0))
    assert_false(ka.move?( 1,  0))
    assert_true(ka.move?( -1, -1))
    assert_false(ka.move?( 0, -1))
    assert_true(ka.move?(  1, -1))
    assert_true(ka.move?(  2, -2))
    assert_true(ka.move?(  2,  2))
  end

  def test_um
    um = Shogi::Piece::UM.new
    assert_equal("UM", um.csa)
    assert_equal("+B", um.usi)
    assert_true(um.move?( -1,  1))
    assert_true(um.move?( -2,  2))
    assert_true(um.move?(  0,  1))
    assert_true(um.move?(  1,  1))
    assert_true(um.move?( -1,  0))
    assert_true(um.move?(  1,  0))
    assert_true(um.move?( -1, -1))
    assert_true(um.move?(  0, -1))
    assert_true(um.move?(  1, -1))
    assert_true(um.move?(  2, -2))
    assert_true(um.move?(  2,  2))
    assert_false(um.move?( 1,  2))
  end

  def test_hi
    hi = Shogi::Piece::HI.new
    assert_equal("HI", hi.csa)
    assert_equal("R", hi.usi)
    assert_false(hi.move?(-1,  1))
    assert_true(hi.move?(  0,  1))
    assert_false(hi.move?( 1,  1))
    assert_true(hi.move?( -1,  0))
    assert_true(hi.move?(  1,  0))
    assert_false(hi.move?(-1, -1))
    assert_true(hi.move?(  0, -1))
    assert_true(hi.move?(  0, -2))
    assert_false(hi.move?( 1, -1))
  end

  def test_ry
    ry = Shogi::Piece::RY.new
    assert_equal("RY", ry.csa)
    assert_equal("+R", ry.usi)
    assert_true(ry.move?( -1,  1))
    assert_true(ry.move?(  0,  1))
    assert_true(ry.move?(  1,  1))
    assert_true(ry.move?( -1,  0))
    assert_true(ry.move?(  1,  0))
    assert_true(ry.move?( -1, -1))
    assert_true(ry.move?(  0, -1))
    assert_true(ry.move?(  0, -2))
    assert_true(ry.move?(  1, -1))
    assert_false(ry.move?( 1, -2))
  end

  def test_ou
    ou = Shogi::Piece::OU.new
    assert_equal("OU", ou.csa)
    assert_equal("K", ou.usi)
    assert_true(ou.move?(-1,  1))
    assert_true(ou.move?( 0,  1))
    assert_true(ou.move?( 1,  1))
    assert_true(ou.move?(-1,  0))
    assert_true(ou.move?( 1,  0))
    assert_true(ou.move?(-1, -1))
    assert_true(ou.move?( 0, -1))
    assert_true(ou.move?( 1, -1))
  end

  private
  def assert_ki(piece)
    assert_true(piece.move?(-1,  1))
    assert_true(piece.move?( 0,  1))
    assert_true(piece.move?( 1,  1))
    assert_true(piece.move?(-1,  0))
    assert_true(piece.move?( 1,  0))
    assert_true(piece.move?( 0, -1))
    assert_false(piece.move?(-1, -1))
    assert_false(piece.move?( 1, -1))
  end
end
