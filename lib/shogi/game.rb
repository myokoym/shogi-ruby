module Shogi
  class Game
    attr_accessor :default_format
    attr_reader :turn
    def initialize(format=:csa, turn="+")
      raise ArgumentError, "Undefined format: #{format}" unless /\Acsa\z/ =~ format
      raise ArgumentError, "Invalid turn: #{turn}" unless /\A[+-]\z/ =~ turn

      @default_format = format
      @board = Shogi::Board.new(@default_format)
      @turn = turn
      @kifu = []
    end

    def to_csa
      @board.to_csa << turn << "\n"
    end

    def move(movement_lines, format=@default_format)
      movement_lines.each_line do |movement|
        movement.chomp!
        @board.move(movement, format)
        @kifu << movement
        @turn = (@turn == "+") ? "-" : "+"
      end
      self
    end

    def kifu
      @kifu.join("\n") << "\n"
    end

    def show(format=@default_format)
      $stdout.puts __send__("to_#{format}")
    end
  end
end
