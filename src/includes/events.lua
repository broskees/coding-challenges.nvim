Events = {}
Events.__index = Events
Events.registry = {}
Events.registry.events = {}
Events.registry.filters = {}

function Events:fire(event, ...)
    if not self.registry.events[event] then
        return
    end

    for _, callback in pairs(self.registery[event]) do
        callback(...)
    end
end

function Events:filter(filter, value, ...)
    if not self.registry.filters[filter] then
        return value
    end

    for _, callback in pairs(self.registry.filters[filter]) do
        value = callback(value, ...)
    end

    return value
end

function Events:register(event, callback)
    if not self.registry.events[event] then
        self.registry.events[event] = {}
    end

    table.insert(self.registry.events[event], callback)
end

function Events:registerFilter(filter, callback)
    if not self.registry.filters[filter] then
        self.registry.filters[filter] = {}
    end

    table.insert(self.registry.filters[filter], callback)
end

return Events
