module Shogi
  class Board
    class Error < StandardError
    end

    def initialize(csa=nil)
      if csa
        set_from_csa(csa)
      else
      @position = default_position
      @captured = []
      end
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

    def set_from_csa(csa)
      position = []
      cell_pattern = '[+-][A-Z]{2}| \* '
      csa_lines = csa.each_line.to_a
      csa_lines.slice(0, 9).to_enum.with_index do |row, i|
        position_row = []
        row.chomp!
        unless /\AP#{i + 1}(#{cell_pattern}){9}\z/ =~ row
          raise Error, "Format Error: line #{i + 1}"
        end
        row[2..28].scan(/#{cell_pattern}/) do |cell|
          position_row << cell
        end
        position << position_row
      end
      @position = position

      captured = []
      csa_lines.slice(9, 2).each do |captured_line|
        captured_line.chomp!
        unless /\AP[+-](00[A-Z]{2})*\z/ =~ captured_line
          raise Error, "Format Error: captured line"
        end
        turn = captured_line[1]
        captured_line[2..-1].scan(/00([A-Z]{2})/) do |cell|
          captured << turn + cell[0]
        end
      end
      @captured = captured
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
        before_piece = eval("Piece::#{before_cell[1..2]}").new
      else
        before_x = 9 - csa[1].to_i
        before_y = csa[2].to_i - 1
        before_cell = @position[before_y][before_x]
        return false if before_cell == ""
        before_piece = eval("Piece::#{before_cell[1..2]}").new

        unless csa[0] == before_cell[0]
          return false
        end
        unless csa[5..6] == before_cell[1..2]
          after_piece = eval("Piece::#{csa[5..6]}").new
          unless before_piece.promoter == after_piece.class
            return false
          end
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

        unless before_piece.move?(movement_x, movement_y)
          return false
        end
      end

      unless after_cell == ""
        after_piece = eval("Piece::#{after_cell[1..2]}").new
        if after_piece.class.const_defined?(:CHILD)
          @captured << "#{csa[0]}#{after_piece.class::CHILD}"
        else
          @captured << "#{csa[0]}#{after_cell[1..2]}"
        end
      end
      @position[after_y][after_x] = "#{csa[0]}#{csa[5..6]}"

      if csa[1..2] == "00"
        used = nil

        @captured.each_with_index do |captured_piece, i|
          if captured_piece == before_cell
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
