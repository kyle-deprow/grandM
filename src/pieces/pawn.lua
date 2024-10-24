require("globals")

Pawn = Piece:extend()

function Pawn:new(color, position)
  local instance = Piece:new("Pawn", color, position)
  setmetatable(instance, Pawn)
  -- Load the texture based on the color
  if color == C.WHITE then
    instance.texture = love.graphics.newImage("./resources/textures/alpha/150/WhitePawn.png")
  else
    instance.texture = love.graphics.newImage("./resources/textures/alpha/150/BlackPawn.png")
  end
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