require 'shogi/board'
require 'stringio'

class SFENTest < Test::Unit::TestCase
  def test_sfen_1
    @game = Shogi::Game.new
    assert_equal('lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 0', @game.to_sfen)
  end

  def test_sfen_2
    @game = Shogi::Game.new
    @game.move('+7776FU', :csa)
    @game.move('-3334FU', :csa)
    @game.move('+2726FU', :csa)
    @game.move('-8384FU', :csa)
    @game.move('+2625FU', :csa)
    @game.move('-8485FU', :csa)
    @game.move('+6978KI', :csa)
    @game.move('-4132KI', :csa)
    @game.move('+2524FU', :csa)
    @game.move('-2324FU', :csa)
    @game.move('+2824HI', :csa)
    @game.move('-8586FU', :csa)
    @game.move('+8786FU', :csa)
    @game.move('-8286HI', :csa)
    @game.move('+2434HI', :csa)
    assert_equal('lnsgk1snl/6gb1/p1pppp2p/6R2/9/1rP6/P2PPPP1P/1BG6/LNS1KGSNL w 3P2p 15', @game.to_sfen)
  end
end
