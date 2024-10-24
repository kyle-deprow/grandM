-- piece.lua
require("engine/sprite")

-- Base Piece class
Piece = Sprite:extend()

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