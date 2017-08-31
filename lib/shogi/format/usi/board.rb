module Shogi
  module Format
    module USI
      module Board
        def to_usi
          @table.map {|row|
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

        def usi_captured
          ['+', '-'].map do |prefix|
            caps = @captured
                   .select { |x| x[0] == prefix }
                   .map { |x| x[1..-1] }
                   .group_by { |x| x }
                   .map { |w, ws| [w, ws.length] }
                   .to_h
            [Piece::HI,
             Piece::KA,
             Piece::KI,
             Piece::GI,
             Piece::KE,
             Piece::KY,
             Piece::FU].map do |type|
              n = caps[type::CSA_NAME] || 0
              usi = type::USI_NAME
              usi = usi.downcase if prefix == '-'
              "#{n}#{usi}" if n > 0
            end.join
          end.join.tap do |x|
            return '-' if x == ''
          end
        end
      end
    end
  end
end
