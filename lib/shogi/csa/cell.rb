module Shogi
  module CSA
    module Cell
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
end
