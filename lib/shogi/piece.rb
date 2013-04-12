require "shogi/piece/base"
require "shogi/piece/promoter"

module Shogi
  module Piece
    class FU < Base
      CSA_NAME = "FU"
      USI_NAME = "P"
      MOVEMENTS = [[0, 1]]
      PROMOTER = TO
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS, PROMOTER)
      end
    end
  
    class KY < Base
      CSA_NAME = "KY"
      USI_NAME = "L"
      MOVEMENTS = [(1..8).map {|height| [0, height] }].flatten(1)
      PROMOTER = NY
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS, PROMOTER)
      end
    end
 
    class KE < Base
      CSA_NAME = "KE"
      USI_NAME = "N"
      MOVEMENTS = [[-1, 2],
                   [ 1, 2]]
      PROMOTER = NK
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end

    class GI < Base
      CSA_NAME = "GI"
      USI_NAME = "S"
      MOVEMENTS = [[-1,  1],
                   [ 0,  1],
                   [ 1,  1],
                   [-1, -1],
                   [ 1, -1]]
      PROMOTER = NG
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class KI < Base
      CSA_NAME = "KI"
      USI_NAME = "G"
      MOVEMENTS = [[-1,  1],
                   [ 0,  1],
                   [ 1,  1],
                   [-1,  0],
                   [ 1,  0],
                   [ 0, -1]]
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end

    class KA < Base
      CSA_NAME = "KA"
      USI_NAME = "B"
      MOVEMENTS = [(-8..-1).collect {|a| [a,  a] },
                   ( 1.. 8).collect {|a| [a,  a] },
                   (-8..-1).collect {|a| [a, -a] },
                   ( 1.. 8).collect {|a| [a, -a] }].flatten(1)
      PROMOTER = UM
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS, PROMOTER)
      end
    end
  
    class HI < Base
      CSA_NAME = "HI"
      USI_NAME = "R"
      MOVEMENTS = [(-8..-1).collect {|h| [0, h] },
                   ( 1.. 8).collect {|h| [0, h] },
                   (-8..-1).collect {|w| [w, 0] },
                   ( 1.. 8).collect {|w| [w, 0] }].flatten(1)
      PROMOTER = RY
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS, PROMOTER)
      end
    end
  
    class OU < Base
      CSA_NAME = "OU"
      USI_NAME = "K"
      MOVEMENTS = [[-1,  1],
                   [ 0,  1],
                   [ 1,  1],
                   [-1,  0],
                   [ 1,  0],
                   [-1, -1],
                   [ 0, -1],
                   [ 1, -1]]
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  end
end

