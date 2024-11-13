require("engine/object")
require("engine/node")
require("engine/moveable")
require("engine/sprite")
require("manager")
require("globals")

function love.load()
  love.graphics.setBackgroundColor(C.GRAY)
  manager = GameManager:new()
end

function love.update(dt)
  manager:update(dt)
end

function love.draw()
  manager:draw()
end

function love.keypressed(key)
  manager:keypressed(key)
end

function love.mousepressed(x, y, button)
  manager:mousepressed(x, y, button)
end

function love.mousemoved(x, y)
  manager:mousemoved(x, y)
end

function love.mousereleased(x, y, button)
  manager:mousereleased(x, y, button)
end