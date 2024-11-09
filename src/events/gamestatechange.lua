require("events/event")

GameStateChange = Event:extend()

function GameStateChange:new(newState, player, triggeredBy)
  local instance = Event.new(self, "GAME_STATE_CHANGE")
  instance.newState = newState
  instance.player = player or "UNDEFINED"
  instance.triggeredBy = triggeredBy or "UNDEFINED"
  return instance
end

function GameStateChange:getNewState()
  return self.newState
end

function GameStateChange:getPlayer()
  return self.player
end

function GameStateChange:getTriggeredBy()
  return self.triggeredBy
end

-- Override serialize method
function GameStateChange:serialize()
  local baseData = Event.serialize(self)
  baseData.newState = self.newState
  baseData.player = self.player
  baseData.triggeredBy = self.triggeredBy
  return baseData
end

-- Override isValid method
function GameStateChange:isValid()
  local baseValid = Event.isValid(self)
  return baseValid and
         self.newState and
         self.player and
         GameStateChange.VALID_STATES[self.newState:upper()]
end

return GameStateChange