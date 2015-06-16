module Shogi
  module Format
    module CSA
      module Board
        def to_csa
          csa_rows = ""

          @table.each_with_index do |row, i|
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

        def parse_from_csa(csa)
          table = []
          cell_pattern = '[+-][A-Z]{2}| \* '
          csa_lines = csa.each_line.to_a
          csa_lines.slice(0, 9).to_enum.with_index do |row, i|
            table_row = []
            row.chomp!
            unless /\AP#{i + 1}(#{cell_pattern}){9}\z/ =~ row
              raise FormatError, "Format Error: line P#{i + 1}"
            end
            row[2..28].scan(/#{cell_pattern}/) do |cell|
              if cell == " * "
                table_row << ""
              else
                table_row << cell
              end
            end
            table << table_row
          end

          captured = []
          csa_lines.slice(9, 2).each do |captured_line|
            captured_line.chomp!
            unless /\AP[+-](00[A-Z]{2})*\z/ =~ captured_line
              raise FormatError, "Invalid format: #{captured_line}"
            end
            turn = captured_line[1]
            captured_line[2..-1].scan(/00([A-Z]{2})/) do |cell|
              captured << turn + cell[0]
            end
          end

          [table, captured]
        end

        private
        def move_by_csa(csa)
          unless /\A[+-](00|[1-9]{2})[1-9]{2}[A-Z]{2}\z/ =~ csa
            raise FormatError, "Invalid CSA format: #{csa}"
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
            before_piece = Piece.const_get(before_cell[1..2]).new
          else
            before_x = to_array_x_from_shogi_x(csa[1].to_i)
            before_y = to_array_y_from_shogi_y(csa[2].to_i)
            before_cell = @table[before_y][before_x]
            if before_cell == ""
              raise MoveError, "Before cell is blank"
            end
            before_piece = Piece.const_get(before_cell[1..2]).new

            unless csa[0] == before_cell[0]
              raise MoveError, "Not your piece: #{before_cell}"
            end
            unless csa[5..6] == before_cell[1..2]
              after_piece = Piece.const_get(csa[5..6]).new
              unless before_piece.promoter == after_piece.class
                raise MoveError, "Can't promote: #{before_cell[1..2]} -> #{csa[5..6]}"
              end

              after_y = to_array_y_from_shogi_y(csa[4].to_i)
              if csa[0] == "+"
                unless after_y < 3 || before_y < 3
                  raise_movement_error("Can't promote: #{csa}")
                end
              else
                unless after_y > 5 || before_y > 5
                  raise_movement_error("Can't promote: #{csa}")
                end
              end
            end
          end

          after_x = to_array_x_from_shogi_x(csa[3].to_i)
          after_y = to_array_y_from_shogi_y(csa[4].to_i)
          after_cell = @table[after_y][after_x]
          if csa[0] == after_cell[0]
            raise MoveError, "Your piece exists in the cell: #{csa}"
          end

          if csa[1..2] == "00"
            unless after_cell == ""
              raise MoveError, "A piece exists in the cell: #{csa}"
            end
          else
            sign = csa[0] == '+' ? 1 : -1
            movement_x = (after_x - before_x) * sign
            movement_y = (before_y - after_y) * sign

            if (movement_x == 0 || movement_y == 0 || movement_x.abs == movement_y.abs) &&
               [movement_x.abs, movement_y.abs].max >= 2
              xs = (-(movement_x.abs-1)...0).map{|x| sign * (movement_x <=> 0) * x}
              ys = (-(movement_y.abs-1)...0).map{|x| sign * (movement_y <=> 0) * x}
              (xs.empty? ? [0] * ys.size : xs).zip(ys)
                .map{|x, y| [csa[1].to_i + (x || 0), csa[2].to_i + (y || 0)]}
                .each do |x, y|
                if (1..9).include?(x) && (1..9).include?(y)
                  piece = @table[to_array_y_from_shogi_y(y)][to_array_x_from_shogi_x(x)]
                  raise_movement_error("Can't jump over a piece: #{piece}") if piece && !piece.empty?
                end
              end
            end

            unless before_piece.move?(movement_x, movement_y)
              raise_movement_error("Invalid movement: #{csa}")
            end
          end

          unless after_cell == ""
            after_piece = Piece.const_get(after_cell[1..2]).new
            if after_piece.class.const_defined?(:CHILD)
              @captured << "#{csa[0]}#{after_piece.class::CHILD}"
            else
              @captured << "#{csa[0]}#{after_cell[1..2]}"
            end
          end
          @table[after_y][after_x] = "#{csa[0]}#{csa[5..6]}"

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
            @table[before_y][before_x] = ""
          end

          self
        end
      end
    end
  end
end
