require "shogi/format/csa/board"
require "shogi/format/usi/board"

module Shogi
  class Error               < StandardError; end
  class CodingError         < Error; end
  class FormatError         < Error; end
  class UndefinedPieceError < Error; end
  class MoveError           < Error; end
  class MovementError       < Error; end

  class Board
    def self.register(name)
      send(:include, Format.const_get(name).const_get("Board"))
    end
    self.register("CSA")
    self.register("USI")

    attr_accessor :default_format
    attr_accessor :validate_movement
    def initialize(default_format=:csa, table=nil)
      @default_format = default_format
      set_from_csa(table || default_table)
      @validate_movement = true
    end

    def move(movement_lines, format=@default_format)
      movement_lines.each_line do |movement|
        movement.chomp!
        __send__("move_by_#{format.to_s}", movement)
      end
      self
    end

    def at(place)
      array_x = to_array_x_from_shogi_x(place[0].to_i)
      array_y = to_array_y_from_shogi_y(place[1].to_i)
      @table[array_y][array_x]
    end

    def show(format=@default_format)
      $stdout.puts __send__("to_#{format}")
    end

    private
    def default_table
      <<-TABLE
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
      TABLE
    end

    def raise_movement_error(message)
      if @validate_movement
        raise MovementError, message
      end
    end

    def to_array_x_from_shogi_x(shogi_x)
      9 - shogi_x
    end

    def to_array_y_from_shogi_y(shogi_y)
      shogi_y - 1
    end

    def to_shogi_x_from_array_x(array_x)
      9 - array_x
    end

    def to_shogi_y_from_array_y(array_y)
      array_y + 1
    end
  end
end
