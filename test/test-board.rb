require "shogi/board"
require "stringio"

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
    position = <<-EOT
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
    @board = Shogi::Board.new(:csa, position)
    assert_equal(position, @board.to_csa)
    assert_nothing_raised do
      @board.move("+0031HI")
    end
    assert_equal(<<-EOT, @board.to_csa)
P1 *  *  *  * +HI * +HI-KE * 
P2 *  *  *  *  * +KA-OU * -KY
P3 *  *  *  *  *  * -FU-FU-FU
P4 *  *  *  * +KY *  * -GI * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7 *  *  *  *  *  *  *  *  * 
P8 *  *  *  *  *  *  *  *  * 
P9 *  *  *  *  *  *  *  *  * 
P+00GI00KE
P-
    EOT
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

  def test_show
    before_state = @board.instance_variable_get(:@position).dup
    s = ""
    io = StringIO.new(s)
    $stdout = io
    @board.default_format = :csa

    @board.show

    $stdout = STDOUT
    assert_equal(<<-EOT, s)
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
    assert_nothing_raised do
      @board.move("+0031HI", :csa)
    end
  end

  def test_to_usi
    before_state = @board.instance_variable_get(:@position).dup
    assert_equal(<<-EOT, @board.to_usi)
lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL
    EOT
    assert_equal(before_state, @board.instance_variable_get(:@position))
  end

  def test_move_csa
    @board.default_format = :csa

    assert_raise Shogi::Board::FormatError do
      @board.move("+27FU")
    end
    assert_raise Shogi::Board::UndefinedPieceError do
      @board.move("+2726AA")
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move("+2726HI"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move("+2827HI"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move("+2625FU"))
    end
    assert_raise Shogi::Board::MovementError do
      assert_false(@board.move("+2725FU"))
    end
    assert_raise Shogi::Board::MoveError do
      assert_false(@board.move("-4131KI"))
    end

    assert_nothing_raised do
      @board.move("+7776FU")
      @board.move("-4132KI")
      @board.move("+2868HI")
    end

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

  def test_move_csa_chain
    assert_nothing_raised do
      @board.move("+7776FU", :csa).move("-4132KI", :csa)
    end
    assert_equal(<<-EOT, @board.to_csa)
P1-KY-KE-GI-KI-OU * -GI-KE-KY
P2 * -HI *  *  *  * -KI-KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  * +FU *  *  *  *  *  * 
P7+FU+FU * +FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
    EOT
  end

  def test_move_csa_at_captured
    assert_nothing_raised do
      @board.move("+7776FU", :csa)
      @board.move("-3334FU", :csa)
      @board.move("+8822KA", :csa)
      @board.move("-3122GI", :csa)
    end
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
    assert_nothing_raised do
      @board.move("+0055KA", :csa)
    end
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

  def test_move_csa_promote
    @board.move("+7776FU", :csa)
    @board.move("-3334FU", :csa)
    assert_raise Shogi::Board::MovementError do
      assert_false(@board.move("+2726TO", :csa))
    end
    assert_nothing_raised do
      @board.move("+8822UM", :csa)
    end
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
    assert_nothing_raised do
      @board.move("-3122GI", :csa)
    end
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
    assert_nothing_raised do
      @board.move("+0033KA", :csa)
      @board.move("-0078KA", :csa)
      @board.move("+3366UM", :csa)
      @board.move("-7867UM", :csa)
    end
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

  def test_move_csa_lines
    csa_lines = <<-EOT
+7776FU
-3334FU
+8822KA
-3122GI
+0055KA
    EOT

    @board.move(csa_lines, :csa)

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

  def test_validate_movement_false
    assert_true(@board.validate_movement)
    @board.validate_movement = false
    assert_false(@board.validate_movement)
    assert_nothing_raised do
      @board.move("+2755FU", :csa)
    end
  end
end
