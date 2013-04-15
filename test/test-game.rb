require "shogi/game"

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
end
