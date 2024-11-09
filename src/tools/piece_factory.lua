require("pieces.pawn")
require("pieces.knight")
require("pieces.bishop")

local pieceClasses = {
  pawn = Pawn,
  knight = Knight,
  bishop = Bishop
}

-- Factory function to create a piece from JSON config object
function CreatePieceFromConfig(pieceConfig)
  -- Get the piece type from the config
  local pieceType = pieceConfig.type:lower()  -- Ensure type is lowercase for matching

  -- Find the corresponding class in the mapping table
  DebugPrint("PIECES", "Creating piece with type:", pieceType)
  local pieceClass = pieceClasses[pieceType]
  if not pieceClass then
    error("Unknown piece type: " .. pieceType)
  end

  -- Create and return an instance of the piece
  DebugPrint("PIECES", "Piece class found:", pieceClass)
  return pieceClass:new(pieceConfig)
end