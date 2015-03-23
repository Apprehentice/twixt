Twixt
=====
Twixt is a tweening library made for LÖVE. It supports easing and time scaling and works on any Lua table with numeric fields.

## Usage ##
To use Twixt, require it, create a Twixt object, and add tweens to it. To add a tween, create a table representing the end result of the tween and pass it and the object to modify to the *addTween* method.

## Example ##
This example will draw a rotating object in the center of the screen.
```Lua
local Twixt = require("twixt")

local tween = Twixt()
local dir = 1

local object = {
  image = love.graphics.newImage("object.png"),
  x = 400,
  y = 300,
  orientation = -math.pi/3
}

function onComplete(self)
  dir = dir * -1
  tween:addTween(object, {
    orientation = dir * (math.pi/3),
    duration = 0.25,
    onComplete = onComplete
  })
end

tween:addTween(object, {
  orientation = math.pi/3,
  duration = 0.25,
  onComplete = onComplete
})

function love.update(dt)
  tween:update(dt)
end

function love.draw()
  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.clear()
  love.graphics.draw(object.image, object.x, object.y, object.orientation, 1, 1, object.image:getWidth()/2, object.image:getHeight()/2)
end

```
