--
--

local Direction = class("Direction")

STEP = 33
INIT_X = 11*STEP
INIT_Y = 15*STEP


function Direction:ctor()
    self._current = self
end

function Direction:create(directionStr)
    local direction = Direction.new();

    direction._top =  require("app.core.state.direction.Top").new();
    direction._right =  require("app.core.state.direction.Right").new();
    direction._left =  require("app.core.state.direction.Left").new();
    direction._bottom =  require("app.core.state.direction.Bottom").new();

    direction._stateArray = {top=direction._top,
        right=direction._right,
        left=direction._left,
        bottom=direction._bottom }
    direction._current = direction._stateArray[directionStr]
    direction._directionStr = directionStr

    return direction
end

function Direction:changeDirection(directionState,node)
    self._current:changeDirection(directionState,node)
end
function Direction:getDirectionStr()
    return self._current:getDirectionStr()
end


function Direction:getPosition(index)
    return self._current:getPosition(index);
end

function Direction:getNextNodePosition(x,y)
    return self._current:getNextNodePosition(x,y)
end

function Direction:getSprite()
    return self._current:getSprite()
end

return Direction