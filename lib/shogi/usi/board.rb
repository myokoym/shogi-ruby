module Shogi
  module USI
    module Board
      def to_usi
        @position.map {|row|
          usi_row = ""
          space_count = 0
          row.each do |cell|
            if cell == ""
              space_count += 1
            else
              if space_count > 0
                usi_row << space_count.to_s
                space_count = 0
              end
              usi = Piece.const_get(cell[1..2]).new.usi
              if cell[0] == "-"
                usi_row << usi.downcase
              else
                usi_row << usi
              end
            end
          end
          if space_count > 0
            usi_row << space_count.to_s
            space_count = 0
          end
          usi_row
        }.join("/") << "\n"
      end
    end
  end
end
