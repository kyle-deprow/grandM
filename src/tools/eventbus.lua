EventBus = {}
EventBus.__index = EventBus

function EventBus:new()
  local instance = setmetatable({}, EventBus)
  instance.subscribers = {}
  return instance
end

function EventBus:subscribe(eventName, callback)
  if not self.subscribers[eventName] then
    self.subscribers[eventName] = {}
  end
  table.insert(self.subscribers[eventName], callback)
end

function EventBus:publish(event)
  if not event:isValid() then
    DebugPrint("EVENTBUS", "Warning: Attempted to publish invalid event")
    return false
  end

  local eventType = event:getEventType()
  if self.subscribers[eventType] then
    for _, callback in ipairs(self.subscribers[eventType]) do
      callback(event)
    end
  end
  return true
end

function EventBus:unsubscribe(eventName, callback)
  if self.subscribers[eventName] then
    for i, subscribedCallback in ipairs(self.subscribers[eventName]) do
      if subscribedCallback == callback then
        table.remove(self.subscribers[eventName], i)
        break
      end
    end
  end
end

return EventBus