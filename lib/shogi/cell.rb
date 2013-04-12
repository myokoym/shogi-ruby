module Shogi
  class Cell
    USI_VERTICAL_LABELS = {
      "1" => "a",
      "2" => "b",
      "3" => "c",
      "4" => "d",
      "5" => "e",
      "6" => "f",
      "7" => "g",
      "8" => "h",
      "9" => "i",
    }

    attr_reader :x, :y
    attr_reader :piece
    attr_accessor :upward
    def initialize(x, y, piece=nil, upward=nil)
      @x = x
      @y = y
      @piece = piece
      @upward = upward
    end

    def place_csa
      "#{x}#{y}"
    end

    def place_usi
      "#{x}#{USI_VERTICAL_LABELS[y]}"
    end

    def piece_csa
      if @piece
        "#{upward ? "+" : "-"}#{@piece.csa}"
      else
        " * "
      end
    end

    def piece_usi
      if @piece
        if @upward
          @piece.usi
        else
          @piece.usi.downcase
        end
      else
        1
      end
    end
  end
end
