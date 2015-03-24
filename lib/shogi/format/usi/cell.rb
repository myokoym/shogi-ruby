module Shogi
  module Format
    module USI
      module Cell
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

        def place_usi
          "#{x}#{USI_VERTICAL_LABELS[y]}"
        end

        def piece_usi
          if @piece
            if @turn
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
  end
end
