require("pieces.pawn")

local pieceClasses = {
  pawn = Pawn
}

-- Factory function to create a piece from JSON config object
function CreatePieceFromConfig(pieceConfig)
  -- Get the piece type from the config
  local pieceType = pieceConfig.type:lower()  -- Ensure type is lowercase for matching

  -- Find the corresponding class in the mapping table
  local pieceClass = pieceClasses[pieceType]
  if not pieceClass then
    error("Unknown piece type: " .. pieceType)
  end

  -- Create and return an instance of the piece
  return pieceClass:new(pieceConfig)
end