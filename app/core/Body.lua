--
-- 蛇身


local Body = class("Body")

function Body:ctor(isHead,x,y,directionState)
    self._directionState = directionState
    self._isHead = isHead;
    self._x = x;
    self._y = y;

    self:changeHead();
    self._change = false
    self._node = display.newNode()
    :addChild(self._sp)
    :setPosition(self._x,self._y)
    :setAnchorPoint(0,0)


end

function Body:changeHead()

    if self._isHead then
--        dump(self._directionState)
        self._sp = self._directionState:getSprite()

        if self._change then

            self._node:removeAllChildren()
            :addChild(self._sp)
            self._change = false
        end

    else
        self._sp = display.newSprite("body.png");
        self._sp:setAnchorPoint(0,0)
    end

end

function Body:setNextNodePosition()
    local ex,ey = self._directionState:getNextNodePosition(self._node:getPosition())
    self._node:setPosition(ex,ey)
end

function Body:getDirectionState()
    return self._directionState
end
function Body:changeDirectionState(directionState)
    self._change = true
    self._directionState:changeDirection(directionState,self)
    self:changeHead()
end
function Body:setDirectionState(directionState)
    self._directionState = directionState
end
function Body:getNode()
    return self._node;
end
return Body