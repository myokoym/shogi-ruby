require "shogi/format/csa/cell"
require "shogi/format/usi/cell"

module Shogi
  class Cell
    include Format::CSA::Cell
    include Format::USI::Cell

    attr_reader :x, :y
    attr_accessor :piece
    attr_accessor :turn
    def initialize(x, y, piece=nil, turn=nil)
      @x = x
      @y = y
      @piece = piece
      @turn = turn
    end
  end
end
