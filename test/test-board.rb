require "shogi/board"

class BoardTest < Test::Unit::TestCase
  def setup
    @board = Shogi::Board.new
  end

  def test_initialize
    rows = @board.instance_variable_get(:@position)
    assert_equal(9, rows.size)
    assert_true(rows.all? {|row| row.size == 9 })
  end

  def test_initialize_csa
    csa = <<-EOT
P1 *  *  *  * +HI *  * -KE * 
P2 *  *  *  *  * +KA-OU * -KY
P3 *  *  *  *  *  * -FU-FU-FU
P4 *  *  *  * +KY *  * -GI * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7 *  *  *  *  *  *  *  *  * 
P8 *  *  *  *  *  *  *  *  * 
P9 *  *  *  *  *  *  *  *  * 
P+00HI00GI00KE
P-
    EOT
    @board = Shogi::Board.new(csa)
    assert_equal(csa, @board.to_csa)
  end

  def test_to_csa
    before_state = @board.instance_variable_get(:@position).dup
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
    EOT
    assert_equal(before_state, @board.instance_variable_get(:@position))
  end

  def test_set_from_csa
    csa = <<-EOT
P1 *  *  *  * +HI *  * -KE * 
P2 *  *  *  *  * +KA-OU * -KY
P3 *  *  *  *  *  * -FU-FU-FU
P4 *  *  *  * +KY *  * -GI * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7 *  *  *  *  *  *  *  *  * 
P8 *  *  *  *  *  *  *  *  * 
P9 *  *  *  *  *  *  *  *  * 
P+00HI00GI00KE
P-
    EOT
    @board.set_from_csa(csa)
    assert_equal(csa, @board.to_csa)
  end

  def test_to_usi
    before_state = @board.instance_variable_get(:@position).dup
    assert_equal(<<-EOT, @board.to_usi)
lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL
    EOT
    assert_equal(before_state, @board.instance_variable_get(:@position))
  end

  def test_move_from_csa
    assert_raise Shogi::Board::FormatError do
      @board.move_from_csa("+27FU")
    end
    assert_raise Shogi::Board::UndefinedPieceError do
      @board.move_from_csa("+2726AA")
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("+2726HI"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("+2827HI"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("+2625FU"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("+2725FU"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("-4131KI"))
    end
    assert_true(@board.move_from_csa("+7776FU"))
    assert_true(@board.move_from_csa("-4132KI"))
    assert_true(@board.move_from_csa("+2868HI"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU * -GI-KE-KY
P2 * -HI *  *  *  * -KI-KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 * +KA * +HI *  *  *  *  * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
    EOT
  end

  def test_move_from_csa_at_captured
    @board.move_from_csa("+7776FU")
    @board.move_from_csa("-3334FU")
    assert_true(@board.move_from_csa("+8822KA"))
    assert_true(@board.move_from_csa("-3122GI"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -GI * 
P3-FU-FU-FU-FU-FU-FU * -FU-FU
P4 *  *  *  *  *  * -FU *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 *  *  *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+00KA
P-00KA
    EOT
    assert_true(@board.move_from_csa("+0055KA"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -GI * 
P3-FU-FU-FU-FU-FU-FU * -FU-FU
P4 *  *  *  *  *  * -FU *  * 
P5 *  *  *  * +KA *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 *  *  *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-00KA
    EOT
  end

  def test_move_from_csa_promote
    @board.move_from_csa("+7776FU")
    @board.move_from_csa("-3334FU")
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move_from_csa("+2726TO"))
    end
    assert_true(@board.move_from_csa("+8822UM"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * +UM * 
P3-FU-FU-FU-FU-FU-FU * -FU-FU
P4 *  *  *  *  *  * -FU *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 *  *  *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+00KA
P-
    EOT
    assert_true(@board.move_from_csa("-3122GI"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -GI * 
P3-FU-FU-FU-FU-FU-FU * -FU-FU
P4 *  *  *  *  *  * -FU *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 *  *  *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+00KA
P-00KA
    EOT
    assert_true(@board.move_from_csa("+0033KA"))
    assert_true(@board.move_from_csa("-0078KA"))
    assert_true(@board.move_from_csa("+3366UM"))
    assert_true(@board.move_from_csa("-7867UM"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -GI * 
P3-FU-FU-FU-FU-FU-FU * -FU-FU
P4 *  *  *  *  *  * -FU *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU+UM *  *  *  *  * 
P7+FU+FU * -UM+FU+FU+FU+FU+FU
P8 *  *  *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-00FU
    EOT
  end
end
