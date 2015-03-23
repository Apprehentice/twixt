local Twixt = {}

local internalkeys = {
  __time = true,
  __initial = true,
  __change = true,
  duration = true,
  easing = true,
  onComplete = true
}

function Twixt.new()
  local t = {}
  t.tweens = {}
  t.timescale = 1
  return setmetatable(t, { __index = Twixt })
end

function Twixt:update(dt)
  for i, tween in ipairs(self.tweens) do
    local settings = tween[1]
    local object = tween[2]

    assert(type(settings.duration) == "number", "invalid duration")
    if not settings.__time then settings.__time = 0 end
    if not settings.easing then settings.easing = require("twixt.easing").linear end
    if not settings.__initial then
     settings.__initial = {}
     settings.__change = {}
    end

    for key, value in pairs(settings) do
      if not internalkeys[key] then
        local t = type(value)
        if t == "function" then
          value(object, t.easings[settings.easing](settings.__time, 0, 1, settings.duration))
        elseif t == "number" then
          if not settings.__initial[key] then
            settings.__initial[key] = object[key]
            settings.__change[key] = value - settings.__initial[key]
          end

          object[key] = settings.easing(settings.__time, settings.__initial[key], settings.__change[key], settings.duration)
        else
          error("bad field '" .. tostring(key) .. "' (expected function or number, got " .. type(value) .. ")")
        end

        settings.__time = math.min(settings.__time + (self.timescale * dt), settings.duration)
        if settings.__time >= settings.duration then
          if settings.onComplete then
            settings.onComplete(v)
          end
          table.remove(self.tweens, i)
        end
      end
    end
  end
end

function Twixt:addTween(object, settings)
  table.insert(self.tweens, {settings, object})
end

function Twixt:getTimescale()
  return self.timescale
end

function Twixt:setTimescale(ts)
  self.timescale = ts
end

return setmetatable(Twixt, {
  __call = Twixt.new
})
