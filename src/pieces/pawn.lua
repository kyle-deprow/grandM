require("globals")

Pawn = Piece:extend()

function Pawn:new(jsonConfig)
  local instance = Piece:new(jsonConfig)
  setmetatable(instance, Pawn)

  return instance
end

function Pawn:init(...)
  -- Call the parent class's init method
  Piece.init(self, ...)
end

function Pawn:getValidMoves(board)
  local moves = {}
  -- Implement pawn-specific movement logic
  -- For example, moving forward one square, capturing diagonally, etc.
  return moves
end