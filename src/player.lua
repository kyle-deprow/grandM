require("tools/piece_factory")
require("tools/util")

Player = {}
Player.__index = Player

function Player:new(jsonConfigPath)
  local instance = setmetatable({}, Player)

  -- Initialize piece ID counter which will increment for each piece
  instance.pieceId = 0

  local config = ReturnJsonConfig(jsonConfigPath)
  instance.color = config.color
  instance.isInteractive = config.isInteractive
  instance.pieces = {}
  for _, pieceConfig in ipairs(config.pieces) do
    pieceConfig.id = instance.pieceId
    pieceConfig.color = instance.color
    instance.pieces[pieceConfig.id] = CreatePieceFromConfig(pieceConfig)
    instance.pieceId = instance.pieceId + 1
  end

  return instance
end

function Player:setPieces(pieces)
  self.pieces = pieces
end

function Player:getColor()
  return self.color
end

function Player:getPieces()
  return self.pieces
end
