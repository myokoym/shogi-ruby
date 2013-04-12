require "shogi/piece/base"

module Shogi
  module Piece
    MOVEMENTS_KI = [[ 0,  1],
                    [-1,  1],
                    [ 1,  1],
                    [-1,  0],
                    [ 1,  0],
                    [ 0, -1]]

    class TO < Base
      CSA_NAME = "TO"
      USI_NAME = "+P"
      MOVEMENTS = MOVEMENTS_KI  

      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class NY < Base
      CSA_NAME = "NY"
      USI_NAME = "+L"
      MOVEMENTS = MOVEMENTS_KI  
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class NK < Base
      CSA_NAME = "NK"
      USI_NAME = "+N"
      MOVEMENTS = MOVEMENTS_KI  
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class NG < Base
      CSA_NAME = "NG"
      USI_NAME = "+S"
      MOVEMENTS = MOVEMENTS_KI  
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class UM < Base
      CSA_NAME = "UM"
      USI_NAME = "+B"
      MOVEMENTS = [(-8..-1).collect {|a| [a,  a] },
                   ( 1.. 8).collect {|a| [a,  a] },
                   (-8..-1).collect {|a| [a, -a] },
                   ( 1.. 8).collect {|a| [a, -a] },
                   [[-1, 0], [0, -1], [0, 1], [1, 0]]].flatten(1)
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  
    class RY < Base
      CSA_NAME = "RY"
      USI_NAME = "+R"
      MOVEMENTS = [(-8..-1).collect {|h| [0, h] },
                   ( 1.. 8).collect {|h| [0, h] },
                   (-8..-1).collect {|w| [w, 0] },
                   ( 1.. 8).collect {|w| [w, 0] },
                   [[-1, -1], [-1, 1], [1, -1], [1, 1]]].flatten(1)
  
      def initialize
        super(CSA_NAME, USI_NAME, MOVEMENTS)
      end
    end
  end
end

