require("engine/object")
require("engine/node")
require("engine/moveable")
require("engine/sprite")
require("manager")
require("globals")

-- Load Love2D modules
function love.load()
  -- Initialize game manager
  love.graphics.setBackgroundColor(C.GRAY)
  manager = GameManager:new()
  manager:startGame()
end

-- Update game state
function love.update(dt)
  -- Update game manager
  manager:update(dt)
end

-- Render the game
function love.draw()
  -- Draw the current game state
  manager:draw()
end

-- Handle key presses
function love.keypressed(key)
  -- Pass key input to game manager
  manager:keypressed(key)
end