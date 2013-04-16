require "shogi/game"
require "stringio"

class GameTest < Test::Unit::TestCase
  def setup
    @game = Shogi::Game.new
  end

  def test_initialize
    assert_equal(:csa, @game.default_format)
    assert_equal("+", @game.turn)
    assert_equal([], @game.instance_variable_get(:@kifu))
  end

  def test_to_csa
    assert_equal(<<-EOT, @game.to_csa)
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
+
    EOT
  end

  def test_move
    @game.default_format = :csa

    assert_nothing_raised do
      @game.move("+7776FU")
      @game.move("-4132KI")
      @game.move("+2868HI")
    end

    assert_equal(<<-EOT, @game.to_csa)
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
-
    EOT

    assert_equal(<<-EOT, @game.kifu)
+7776FU
-4132KI
+2868HI
    EOT
  end

  def test_show
    @game.default_format = :csa

    s = ""
    io = StringIO.new(s)
    $stdout = io

    @game.show

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
+
    EOT
  end

  def test_show_all
    @game.default_format = :csa
    @game.move("+7776FU")
    @game.move("-3334FU")
    @game.move("+8822UM")

    s = ""
    io = StringIO.new(s)
    $stdout = io

    @game.show_all

    $stdout = STDOUT
    assert_equal(<<-EOT, s)
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
-
+7776FU
-3334FU
+8822UM
    EOT
  end

  def test_at
    @game.default_format = :csa
    @game.move("+7776FU")
    @game.move("-3334FU")
    @game.move("+8822UM")
    @game.move("-3122GI")

    assert_equal(<<-EOT, @game.at(3).to_csa)
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
-
    EOT
  end
end
