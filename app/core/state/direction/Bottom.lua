--
local Bottom = class("Bottom",function()
    return require("app.core.state.direction.Direction").new()
end)


function Bottom:getPosition(index)
    return INIT_X,INIT_Y+index*STEP;
end


function Bottom:getNextNodePosition(x,y)
    return x,y-STEP
end

function Bottom:getSprite()
    local sprite  = display.newSprite("head_bottom.png")
    sprite:setAnchorPoint(0,0)
    return sprite
end

function Bottom:start()
    self._current = self._bottom
end

function Bottom:getDirectionStr()
    return "bottom"
end
function Bottom:changeDirection(directionState,body)
    if directionState:getDirectionStr() ~= "top" then
        body:setDirectionState(directionState)
    end
end

return Bottom
