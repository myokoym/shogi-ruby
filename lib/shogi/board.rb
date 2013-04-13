module Shogi
  class Board
    def initialize
      @position = default_position
      @captured = []
    end

    def to_csa
      @position.map.with_index {|row, i|
        row.map {|cell|
          (cell == "") ? " * " : cell
        }.unshift("P#{i + 1}").join
      }.join("\n") << "\n"
    end

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
            usi = eval("Piece::#{cell[1..2]}.new").usi
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

    def move_from_csa(csa)
      before_x = 9 - csa[1].to_i
      before_y = csa[2].to_i - 1
      before_cell = @position[before_y][before_x]
      unless csa[0] == before_cell[0]
        return false
      end

      after_x = 9 - csa[3].to_i
      after_y = csa[4].to_i - 1
      after_cell = @position[after_y][after_x]
      if csa[0] == after_cell[0]
        return false
      end

      unless csa[5..6] == before_cell[1..2]
        return false
      end

      unless after_cell == ""
        @captured << "#{csa[0]}#{csa[5..6]}"
      end
      @position[after_y][after_x] = before_cell
      @position[before_y][before_x] = ""

      true
    end

    private
    def default_position
      [["-KY", "-KE", "-GI", "-KI", "-OU", "-KI", "-GI", "-KE", "-KY"],
       [   "", "-HI",    "",    "",    "",    "",    "", "-KA",    ""],
       ["-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU"],
       [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
       [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
       [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
       ["+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU"],
       [   "", "+KA",    "",    "",    "",    "",    "", "+HI",    ""],
       ["+KY", "+KE", "+GI", "+KI", "+OU", "+KI", "+GI", "+KE", "+KY"]]
    end
  end
end
