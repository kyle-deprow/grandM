require("globals")
require("piece")

Knight = Piece:extend()

function Knight:new(jsonConfig)
  local instance = Piece:new(jsonConfig)
  setmetatable(instance, Knight)

  return instance
end

function Knight:init(...)
  -- Call the parent class's init method
  Piece.init(self, ...)
end

function Knight:_validateUnoccupiedMove(translation)
  -- Knight moves in an L-shape: 2 squares in one direction and 1 square perpendicular
  -- This creates 8 possible moves
  local rowDiff = math.abs(translation:getDifferenceRow())
  local colDiff = math.abs(translation:getDifferenceCol())

  return (rowDiff == 2 and colDiff == 1) or (rowDiff == 1 and colDiff == 2)
end

function Knight:_validateOccupiedMove(translation)
  -- Knights have the same movement pattern whether the destination is occupied or not
  return self:_validateUnoccupiedMove(translation)
end

function Knight:_validatePlacement(translation)
  -- Knights can be placed on the last row in the second or n-1 column
  if (translation:getDestinationTile():getRow() == translation:getBoardRows()) and
     ((translation:getDestinationTile():getCol() == (translation:getBoardCols() - 1)) or
      (translation:getDestinationTile():getCol() == 2)) then
    return true
  end
  return false
end