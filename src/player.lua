require("tools/piece_factory")
require("tools/util")

Player = {}
Player.__index = Player

function Player:new(jsonConfigPath)
  local instance = setmetatable({}, Player)

  -- Initialize piece ID counter which will increment for each piece
  instance.pieceId = 1

  local config = ReturnJsonConfig(jsonConfigPath)
  instance.color = string.upper(config.color)
  instance.isInteractive = config.isInteractive
  instance.pieces = {}
  instance.maxPiecesToPlay = config.maxPiecesToPlay or 0
  for i, pieceConfig in pairs(config.pieces) do
    pieceConfig.id = instance.pieceId
    pieceConfig.color = instance.color
    instance.pieces[instance.pieceId] = CreatePieceFromConfig(pieceConfig)
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

function Player:getPiecesCount()
  return #self.pieces
end

function Player:getMaxPieces()
  return self.maxPiecesToPlay
end

function Player:getIsInteractive()
  return self.isInteractive
end
