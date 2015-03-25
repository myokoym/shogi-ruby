require "shogi/format/csa/cell"
require "shogi/format/usi/cell"

module Shogi
  class Cell
    def self.register(name)
      send(:include, Format.const_get(name).const_get("Cell"))
    end
    self.register("CSA")
    self.register("USI")

    attr_reader :x, :y
    attr_accessor :piece
    attr_accessor :turn
    def initialize(x, y, piece=nil, turn=nil)
      @x = x
      @y = y
      @piece = piece
      @turn = turn
    end
  end
end
