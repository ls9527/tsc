
local Snake = class("Snake");
local bodyClass = require("app.core.Body");
local DirectionClass = require("app.core.state.direction.Direction")
local CollisionManager = require("app.core.CollisionManager");

-- 修改蛇头方向
function Snake:move(direction)
    if not self._refreshHead then
        return;
    end
    self._refreshHead = false
    local directctionState = DirectionClass:create(direction)
    self._bodyArray[1]:changeDirectionState(directctionState)

end

function Snake:update(ft)
    self._refreshHead = true
    -- 移动之前存储最后一个蛇身的位置
    self._lastPositionX,self._lastPositionY = self._bodyArray[#self._bodyArray]:getNode():getPosition()

    -- 遍历蛇身方向
    for i=1,#self._bodyArray,1 do
        self._bodyArray[i]:setNextNodePosition();

        if self._collisionManager ~= nil then
            local x,y = self._bodyArray[i]:getNode():getPosition()
            self._collisionManager:check(self._bodyArray[i]:getNode(),self._bodyArray,function(...)
                self:snakeState(...)
            end)
        end
    end


    for i =#self._bodyArray,2,-1 do
        self._bodyArray[i]:changeDirectionState(self._bodyArray[i-1]:getDirectionState());
    end

end



-- 1 障碍（水泥，蛇身） ,2 苹果  3 传送门
function Snake:snakeState(state,node)
    if state == "1" then
        self._gameMap:gameOver()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._schedule)
    elseif state =="2" then -- 移除苹果，增加蛇身长度，加分
        -- 加分
        self._score = self._score+1;
        self._gameMap:changeScore(self._score)
        -- 增加蛇身
        local lastBody = self._bodyArray[#self._bodyArray];
        local body = bodyClass.new(false, self._lastPositionX,self._lastPositionY,lastBody:getDirectionState());
        table.insert(self._bodyArray,body)
        body:getNode():addTo(self._gameMap);
        -- 重置苹果位置
        self._gameMap:generateFood()
    elseif state =="3" then -- 将碰撞传送门的部位放到另一个传送门的地方
        local csmArray = self._gameMap:getCsmArray()
        local x,y = node:getPosition()
        for i=1,#csmArray,1 do
            if csmArray[i].x == x and csmArray[i].y == y then
                local index = (i==#csmArray) and 1 or i+1
                local point = csmArray[index]
                node:setPosition(point.x,point.y)
            end
        end
    end
end


function Snake:initial()

    for i=1,self._size,1 do
        local x,y = self._directionState:getPosition(i)
        local body = bodyClass.new(i==1,x,y, self._directionState);
        table.insert(self._bodyArray,body)
    end
end
-- 初始化蛇身数量
function Snake:ctor( size,direction)
    self._score = 0
    self._size = size;
    self._bodyArray = {};
    self._refreshHead = true
    self._directionState = DirectionClass:create(direction)
    self:initial();

    self._schedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
        return self:update(dt)
    end, 0.3, false)

end

function Snake:setGameMap(gameMap)
    self._gameMap = gameMap
    self._collisionManager =CollisionManager.new(self._gameMap:getMap())
    for i=1,#self._bodyArray,1 do
        self._bodyArray[i]:getNode():addTo(self._gameMap);
    end

end

return Snake