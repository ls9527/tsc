--
-- Created by IntelliJ IDEA.
-- User: Administrator
-- Date: 2017/3/28
-- Time: 1:49
-- To change this template use File | Settings | File Templates.
--

local Top = class("Top",function()
    return require("app.core.state.direction.Direction").new()
end)

function Top:getPosition(index)
    return INIT_X,INIT_Y-index*STEP;
end


function Top:getNextNodePosition(x,y)
    return x,y+STEP
end

function Top:getSprite()
    local sprite  = display.newSprite("head_top.png")
    sprite:setAnchorPoint(0,0.5)
    return sprite
end

function Top:getDirectionStr()
    return "top"
end
function Top:changeDirection(directionState,body)
    if directionState:getDirectionStr() ~= "bottom" then
        body:setDirectionState(directionState)
    end
end


return Top

