require("globals")
require("piece")

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

function Pawn:_validateUnoccupiedMove(translation)
  -- 1. Destination tile is forward one tile and empty
  -- 2. Destination tile is forward two tiles and empty, along with pawn is at starting position
  return (translation:getDifferenceRow() == -1 and translation:getDifferenceCol() == 0) or
         (translation:getDifferenceRow() == -2 and translation:getDifferenceCol() == 0 and
          translation:getSourceTile():getRow() == translation:getBoardRows() - 1)
end

function Pawn:_validateOccupiedMove(translation)
  -- Pawn occupied destination is valid if:
  -- 1. Destination tile is diagonal and occupied by an enemy piece
  return (translation:getDifferenceRow() == -1 and math.abs(translation:getDifferenceCol()) == 1)
end

function Pawn:_validatePlacement(translation)
  if translation:getDestinationTile():getRow() == translation:getBoardRows() - 1 then
    return true
  end
  return false
end
