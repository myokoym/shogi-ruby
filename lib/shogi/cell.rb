require "shogi/usi/cell"

module Shogi
  class Cell
    include USI::Cell

    attr_reader :x, :y
    attr_accessor :piece
    attr_accessor :turn
    def initialize(x, y, piece=nil, turn=nil)
      @x = x
      @y = y
      @piece = piece
      @turn = turn
    end

    def place_csa
      "#{x}#{y}"
    end

    def piece_csa
      if @piece
        "#{turn ? "+" : "-"}#{@piece.csa}"
      else
        " * "
      end
    end
  end
end
