module Shogi
  class Board
    class Error               < StandardError; end
    class CodingError         < Error; end
    class FormatError         < Error; end
    class UndefinedPieceError < Error; end
    class MoveError           < Error; end
    class MovementError       < Error; end

    attr_accessor :validate_movement
    def initialize(csa=nil)
      if csa
        set_from_csa(csa)
      else
        @position = default_position
        @captured = []
      end
      @validate_movement = true
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
          raise FormatError, "Format Error: line P#{i + 1}"
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
          raise FormatError, "Format Error: captured piece line"
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
        raise FormatError, "Wrong CSA format: #{csa}"
      end

      unless Piece.const_defined?(csa[5..6])
        raise UndefinedPieceError, "Undefined piece: #{csa[5..6]}"
      end

      if csa[1..2] == "00"
        before_piece = csa[0] + csa[5..6]
        unless @captured.include?(before_piece)
          raise MoveError, "Not captured piece: #{before_piece}"
        end
        before_cell = before_piece
        before_piece = eval("Piece::#{before_cell[1..2]}").new
      else
        before_x = 9 - csa[1].to_i
        before_y = csa[2].to_i - 1
        before_cell = @position[before_y][before_x]
        if before_cell == ""
          raise MoveError, "Before cell is blank"
        end
        before_piece = eval("Piece::#{before_cell[1..2]}").new

        unless csa[0] == before_cell[0]
          raise MoveError, "Don't your piece: #{before_cell}"
        end
        unless csa[5..6] == before_cell[1..2]
          after_piece = eval("Piece::#{csa[5..6]}").new
          unless before_piece.promoter == after_piece.class
          raise MoveError, "Don't promote: #{before_cell[1..2]} -> #{csa[5..6]}"
          end

          after_y = csa[4].to_i - 1
          if csa[0] == "+"
            unless after_y < 3 || before_y < 3
              raise_movement_error("Don't promote line: #{csa}")
            end
          else
            unless after_y > 6 || before_y > 6
              raise_movement_error("Don't promote line: #{csa}")
            end
          end
        end
      end

      after_x = 9 - csa[3].to_i
      after_y = csa[4].to_i - 1
      after_cell = @position[after_y][after_x]
      if csa[0] == after_cell[0]
        raise MoveError, "Your piece on after cell: #{csa}"
      end

      if csa[1..2] == "00"
        unless after_cell == ""
          raise MoveError, "Exist piece on after cell"
        end
      else
        if csa[0] == "+"
          movement_x = after_x - before_x
          movement_y = before_y - after_y
        else
          movement_x = before_x - after_x
          movement_y = after_y - before_y
        end

        unless before_piece.move?(movement_x, movement_y)
          raise_movement_error("Invalid movement")
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
          raise CodingError, "[Bug] missing piece in captured"
        end
      else
        @position[before_y][before_x] = ""
      end

      true
    end

    def move_from_csa_lines(csa_lines)
      csa_lines.each_line do |csa|
        csa.chomp!
        move_from_csa(csa)
      end
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

    def raise_movement_error(message)
      if @validate_movement
        raise MovementError, message
      end
    end
  end
end
