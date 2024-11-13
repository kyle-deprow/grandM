require("globals")
require("events/event")

GameStateChange = Event:extend()
GameStateChange.__class = "GameStateChange"

function GameStateChange:new(params)
  local instance = Event.new(self, EVENTS.GAME_STATE_CHANGE, params.triggeredBy)
  instance.newState = params.newState
  return instance
end

-- Getters
function GameStateChange:getNewState() return self.newState end

-- Override serialize method
function GameStateChange:serialize()
  local baseData = Event.serialize(self)
  baseData.newState = self.newState
  return baseData
end

-- Override isValid method
function GameStateChange:isValid()
  local baseValid = Event.isValid(self)
  return baseValid and
         self.newState and
         GameStateChange.VALID_STATES[self.newState:upper()]
end

return GameStateChange