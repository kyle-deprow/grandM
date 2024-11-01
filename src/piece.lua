-- piece.lua
require("engine/sprite")
require("tools/position")

-- Base Piece class
Piece = Sprite:extend()

function Piece:new(pieceConfig)
  local instance = setmetatable({}, self)

  DebugPrint("PIECES", "Creating piece with config:", pieceConfig)
  instance.color = pieceConfig.color
  instance.type = pieceConfig.type
  instance.rank = pieceConfig.rank
  instance.health = pieceConfig.health
  instance.defense = pieceConfig.defense
  instance.items = pieceConfig.items or {}
  instance.start = pieceConfig.start or {offsetX = 0, offsetY = 0}
  instance.id = pieceConfig.id
  instance.position = Position.new(0, 0)
  instance.originalPosition = Position.new(0, 0)
  instance.tile = nil

  instance.texture = love.graphics.newImage(ReturnPieceTextureFile(instance))
	instance.pngSize = 150 -- TODO: Hardcoded for now
  instance.preScaler = 1/(instance.pngSize/(0.96)) --scale *0.96
  instance.scale = 0

  return instance
end

function Piece:init(...)
  -- Call the parent class's init method
  Sprite.init(self, ...)
  -- Additional initialization for Piece
end

function Piece:getValidMoves(board)
  -- Placeholder for getting valid moves
  -- This method should be overridden by specific piece types
  return {}
end

function Piece:draw()
  -- Set the shader
  -- love.graphics.setShader(self.shader)

  -- Set the hue color uniform
  -- self.shader:send("hueColor", {hueColor[1], hueColor[2], hueColor[3]})

  -- Draw the piece's texture at its position
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.texture, self.position.x, self.position.y, 0, self.scale, self.scale)

  -- Reset the shader
  -- love.graphics.setShader()
end

function Piece:calculateScale(tileSize)
  self.scale = self.preScaler * tileSize
  DebugPrint("PIECE", "Calculating scale for piece", self:getId(), "tileSize", tileSize, "preScaler", self.preScaler, "scale", self.scale)
end 

function Piece:resetPosition()
  self.position:set(self.originalPosition:getX(), self.originalPosition:getY())
end 

function Piece:setPosition(position)
  self.position = position
end

function Piece:setOriginalPosition(position)
  self.originalPosition = position
end

function Piece:setTile(tile)
  self.tile = tile
end

function Piece:getId()
  return self.id
end

function Piece:getOriginalPosition()
  return self.originalPosition
end

function Piece:getType()
  return self.type
end

function Piece:getColor()
  return self.color
end

function Piece:getPosition()
  return self.position
end

function Piece:getPngSize()
  return self.pngSize
end

function Piece:getScale()
  return self.scale
end

function Piece:getTexture()
  return self.texture
end

function Piece:getStart()
  return self.start
end

function Piece:getTile()
  return self.tile
end

