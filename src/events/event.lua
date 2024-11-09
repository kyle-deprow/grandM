Event = {}
Event.__index = Event

function Event:new(eventType, timestamp)
  local instance = setmetatable({}, self)
  instance.eventType = eventType or "UNDEFINED"
  instance.timestamp = timestamp or os.time()
  return instance
end

-- Add extend method for inheritance
function Event:extend()
  local cls = {}
  cls.__index = cls
  setmetatable(cls, {
    __index = self,
    __call = function(c, ...)
      local instance = setmetatable({}, c)
      instance:new(...)
      return instance
    end
  })
  return cls
end

function Event:getEventType() return self.eventType end
function Event:getTimestamp() return self.timestamp end

-- Serialize event data for logging or network transmission
function Event:serialize()
  return {
    eventType = self.eventType,
    timestamp = self.timestamp
  }
end

-- Virtual method for validation
function Event:isValid()
  return self.eventType ~= nil and self.eventType ~= "UNDEFINED"
end

return Event