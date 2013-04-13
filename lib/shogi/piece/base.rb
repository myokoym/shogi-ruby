module Shogi
  module Piece
    class Base
      attr_reader :csa, :usi, :promoter
      def initialize(csa, usi, movements, promoter=nil)
        @csa = csa
        @usi = usi
        @movements = movements
        @promoter = promoter
      end

      def move?(width, height)
        @movements.include?([width, height])
      end
    end
  end
end
