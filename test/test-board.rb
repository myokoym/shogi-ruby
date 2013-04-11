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
end
