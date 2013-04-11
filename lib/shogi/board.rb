module Shogi
  class Board
    DEFAULT_POSITION = [
      ["-KY", "-KE", "-GI", "-KI", "-OU", "-KI", "-GI", "-KE", "-KY"],
      [   "", "-HI",    "",    "",    "",    "",    "", "-KA",    ""],
      ["-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU", "-FU"],
      [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
      [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
      [   "",    "",    "",    "",    "",    "",    "",    "",    ""],
      ["+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU", "+FU"],
      [   "", "+KA",    "",    "",    "",    "",    "", "+HI",    ""],
      ["+KY", "+KE", "+GI", "+KI", "+OU", "+KI", "+GI", "+KE", "+KY"],
    ]

    def initialize
      @position = DEFAULT_POSITION.dup
      @captured = []
    end

    def to_csa
      @position.map.with_index {|row, i|
        row.map {|cell|
          (cell == "") ? " * " : cell
        }.unshift("P#{i + 1}").join
      }.join("\n") << "\n"
    end
  end
end
