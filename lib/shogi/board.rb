module Shogi
  class Board
    class Error < StandardError
    end

    def initialize
      @position = default_position
      @captured = []
    end

    def to_csa
      csa_rows = ""

      @position.each_with_index do |row, i|
        csa_row = ""
        row.each do |cell|
          if cell == ""
            csa_row << " * "
          else
            csa_row << cell
          end
        end
        csa_rows << "P#{i + 1}#{csa_row}\n"
      end

      sente = "P+"
      gote = "P-"
      @captured.each do |piece|
        if piece[0] == "+"
          sente << "00#{piece[1..2]}"
        else
          gote << "00#{piece[1..2]}"
        end
      end
      csa_rows << "#{sente}\n"
      csa_rows << "#{gote}\n"

      csa_rows
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
            usi = eval("Piece::#{cell[1..2]}").new.usi
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
      unless /\A[+-](00|[1-9]{2})[1-9]{2}[A-Z]{2}\z/ =~ csa
        raise Error, "Format Error"
      end

      unless Piece.const_defined?(csa[5..6])
        raise Error, "No Defined Piece Error"
      end

      if csa[1..2] == "00"
        before_piece = csa[0] + csa[5..6]
        unless @captured.include?(before_piece)
          return false
        end
        before_cell = before_piece
      else
      before_x = 9 - csa[1].to_i
      before_y = csa[2].to_i - 1
      before_cell = @position[before_y][before_x]
      unless csa[0] == before_cell[0]
        return false
      end
      unless csa[5..6] == before_cell[1..2]
        return false
      end
      end

      after_x = 9 - csa[3].to_i
      after_y = csa[4].to_i - 1
      after_cell = @position[after_y][after_x]
      if csa[0] == after_cell[0]
        return false
      end

      if csa[1..2] == "00"
        return false unless after_cell == ""
      else
      if csa[0] == "+"
        movement_x = after_x - before_x
        movement_y = before_y - after_y
      else
        movement_x = before_x - after_x
        movement_y = after_y - before_y
      end

      unless eval("Piece::#{csa[5..6]}").new.move?(movement_x, movement_y)
        return false
      end
      end

      unless after_cell == ""
        @captured << "#{csa[0]}#{after_cell[1..2]}"
      end
      @position[after_y][after_x] = before_cell

      if csa[1..2] == "00"
        used = nil

        @captured.each_with_index do |piece, i|
          if piece == before_cell
            used = @captured.delete_at(i)
            break
          end
        end

        unless used == before_cell
          raise Error, "[Bug] missing piece in captured"
        end
      else
      @position[before_y][before_x] = ""
      end

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
