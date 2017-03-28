--
local Right = class("Right",function()
    return require("app.core.state.direction.Direction").new()
end)

function Right:getPosition(index)
    return INIT_X-index*STEP,INIT_Y;
end


function Right:getNextNodePosition(x,y)
    return x+STEP,y
end

function Right:getSprite()
    local sprite  = display.newSprite("head_right.png")
    sprite:setAnchorPoint(0.5,0)
    return sprite
end


function Right:getDirectionStr()
    return "right"
end
function Right:changeDirection(directionState,body)
    if directionState:getDirectionStr() ~= "left" then
        body:setDirectionState(directionState)
    end
end

return Right
