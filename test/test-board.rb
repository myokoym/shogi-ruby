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
    EOT
    assert_equal(before_state, @board.instance_variable_get(:@position))
  end

  def test_to_usi
    before_state = @board.instance_variable_get(:@position).dup
    assert_equal(<<-EOT, @board.to_usi)
lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL
    EOT
    assert_equal(before_state, @board.instance_variable_get(:@position))
  end

  def test_move_from_csa
    assert_raise Shogi::Board::Error do
      @board.move_from_csa("+27FU")
    end
    assert_raise Shogi::Board::Error do
      @board.move_from_csa("+2726AA")
    end
    assert_false(@board.move_from_csa("+2726HI"))
    assert_false(@board.move_from_csa("+2827HI"))
    assert_false(@board.move_from_csa("+2625FU"))
    assert_true(@board.move_from_csa("+2726FU"))
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  * +FU * 
P7+FU+FU+FU+FU+FU+FU+FU * +FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
    EOT
  end
end
