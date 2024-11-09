require("globals")
require("piece")

Bishop = Piece:extend()

function Bishop:new(jsonConfig)
  local instance = Piece:new(jsonConfig)
  setmetatable(instance, Bishop)
  return instance
end

function Bishop:init(...)
  -- Call the parent class's init method
  Piece.init(self, ...)
end

function Bishop:_validateUnoccupiedMove(translation)
  -- Bishop moves diagonally: row difference must equal column difference
  local rowDiff = math.abs(translation:getDifferenceRow())
  local colDiff = math.abs(translation:getDifferenceCol())

  -- Check if the move is diagonal
  if rowDiff ~= colDiff then
    return false
  end

  -- Check if there are any pieces blocking the diagonal path
  local rowStep = translation:getDifferenceRow() > 0 and 1 or -1
  local colStep = translation:getDifferenceCol() > 0 and 1 or -1
  local currentRow = translation:getSourceTile():getRow()
  local currentCol = translation:getSourceTile():getCol()

  -- Check each tile along the diagonal path (excluding source and destination)
  for i = 1, rowDiff - 1 do
    currentRow = currentRow + rowStep
    currentCol = currentCol + colStep
    if self:getBoard():isTileOccupied(currentRow, currentCol) then
      return false
    end
  end

  return true
end

function Bishop:_validateOccupiedMove(translation)
  -- Bishops have the same movement pattern whether the destination is occupied or not
  -- but still need to check for blocking pieces
  return self:_validateUnoccupiedMove(translation)
end

function Bishop:_validatePlacement(translation)
  -- Bishops can be placed on the last row in the third or n-2 column
  if (translation:getDestinationTile():getRow() == translation:getBoardRows()) and
     ((translation:getDestinationTile():getCol() == (translation:getBoardCols() - 2)) or
      (translation:getDestinationTile():getCol() == 3)) then
    return true
  end
  return false
end