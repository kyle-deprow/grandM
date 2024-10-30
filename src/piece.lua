-- piece.lua
require("engine/sprite")

-- Base Piece class
Piece = Sprite:extend()

function Piece:new(pieceConfig)
  local instance = setmetatable({}, self)

  instance.texture = love.graphics.newImage(
    TEXTURE_PATH ..
    pieceConfig.color ..
    pieceConfig.type ..
    ".png"
  )

  instance.type = pieceConfig.type
  instance.rank = pieceConfig.rank
  instance.health = pieceConfig.health
  instance.defense = pieceConfig.defense
  instance.items = pieceConfig.items or {}
  instance.originalPosition = nil

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

function Piece:move(newPosition)
  -- Update the piece's position
  self.position = newPosition
end

function Piece:draw()
  -- Set the shader
  -- love.graphics.setShader(self.shader)

  -- Set the hue color uniform
  -- self.shader:send("hueColor", {hueColor[1], hueColor[2], hueColor[3]})

  -- Draw the piece's texture at its position
  love.graphics.draw(self.texture, self.position.x, self.position.y)

  -- Reset the shader
  -- love.graphics.setShader()
end

function Piece:render(x, y)
  -- Draw the pawn texture at the given x, y position
  love.graphics.draw(self.texture, x, y)
end

function Piece:resetPosition()
  self.position = self.originalPosition
end 

function Piece:setPosition(position)
  self.position = position
end

function Piece:getOriginalPosition()
  return self.originalPosition
end

function Piece:setOriginalPosition(position)
  self.originalPosition = position
end

function Piece:getPosition()
  return self.position
end
