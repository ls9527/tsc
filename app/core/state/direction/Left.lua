--
local Left = class("Left",function()
    return require("app.core.state.direction.Direction").new()
end)

function Left:getPosition(index)
    return INIT_X+index*STEP,INIT_Y;
end

function Left:getNextNodePosition(x,y)
    return x-STEP,y
end

function Left:getSprite()
    local sprite  = display.newSprite("head_left.png")
    sprite:setAnchorPoint(0,0)
    return sprite
end

function Left:getDirectionStr()
    return "left"
end
function Left:changeDirection(directionState,body)
    if directionState:getDirectionStr() ~= "right" then
        body:setDirectionState(directionState)
    end
end




return Left
