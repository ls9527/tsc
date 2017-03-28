--
-- 碰撞管理器
-- 触发所有不是空白的事件

local CollisionManager = class("CollisionManager")
function CollisionManager:convertPoint(x,y)
    local row = self._map:getMapSize().height; --得到地图的高，也就是行数
    local tileSize = self._map:getTileSize().width; --获取图块大小，图块为正文形
    local tilePoint = cc.p(x/tileSize, row - 1 - y/tileSize);

    return tilePoint; --返回tile的坐标
end
function CollisionManager:ctor(map)
    self._map = map
end
function CollisionManager:check(checkNode,bodyArray,callback)
    local repeatNumber = 0;
    for i=2,#bodyArray,1 do
        local nx,ny = checkNode:getPosition()
        local bx,by = bodyArray[i]:getNode():getPosition()
        if nx == bx and ny == by then
            repeatNumber =     repeatNumber+1
            if repeatNumber>1 then
                callback("1",checkNode)
            end
        end
    end

    local headPosition = self:convertPoint(checkNode:getPosition())
    local map_layer = self._map:getLayer("group1")
    local git = map_layer:getTileGIDAt(headPosition)
    if git<=0 then
        return
    end

    local properties = self._map:getPropertiesForGID(git)
    if type(properties) == "table" then
        local state = properties.state
        if state ~= nil  then
            callback(state,checkNode)
        end
    end

end

return CollisionManager