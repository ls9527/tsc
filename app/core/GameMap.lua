--
-- 游戏地图

local GameMap = class("GameMap",function()
    return display.newLayer()
end)
-- 初始化键盘操作
function GameMap:initialKeyboard()
    local function keyboardPressed(keyCode, event)
        if keyCode == 26 then
            self._snake:move("left");
        elseif keyCode == 27 then
            self._snake:move("right")
        elseif keyCode == 28 then
            self._snake:move("top")
        elseif keyCode == 29 then
            self._snake:move("bottom")
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end
function GameMap:initialTouch()
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if(event.name=="moved") then
            --左右判断
            if event.x - self._beganX > 0 and math.abs(event.y - self._beganY) <50 then -- 右边
                self._snake:move("right");
            elseif  event.x - self._beganX < 0 and math.abs(event.y - self._beganY) <50 then--左边
                self._snake:move("left");
            --上下判断
            elseif event.y - self._beganY > 0 and math.abs(event.x - self._beganX) <50 then -- 上面
                self._snake:move("top");
            else --下面
                self._snake:move("bottom");
            end
        end
        if event.name == "began" then
            self._beganX = event.x
            self._beganY = event.y
            return true;
        end
    end)
end
-- 构造初始化
function GameMap:ctor()
    self._score = 0
    self._map = cc.TMXTiledMap:create("map2.tmx")
    self._map:addTo(self)
    self:initialKeyboard()
    self:initialTouch()
    self._idleArray = {}
    self._csmArray = {}
    self:generateFood()

    self._gameOver = require("app.scenes.GameOver").new()


    local obj = self._map:getObjectGroup("obj")
    local scoreObj = obj:getObject("score");
    self._scoreLabel = cc.Label:createWithTTF("0", "fonts/arial.ttf", 18)
        :setPosition(scoreObj.x,scoreObj.y)
    self:addChild(self._scoreLabel)

    self:initCsmArray()
end

function GameMap:changeScore(score)
    self._scoreLabel:setString(score);
end
-- 屏幕坐标转tile 坐标
function GameMap:convertPoint(x,y)
    local row = self:getMap():getMapSize().height; --得到地图的高，也就是行数
    local tileSize = self:getMap():getTileSize().width; --获取图块大小，图块为正文形
    local tilePoint = cc.p(x/tileSize, row - 1 - y/tileSize);

    return tilePoint; --返回tile的坐标
end
-- 初始化传送门
function GameMap:initCsmArray()
    local mapLayer= self:getMap():getLayer("group1")
    local vec = mapLayer:getLayerSize ();
    for i=1,vec.width,1 do
        for j=1,vec.height,1 do
            local x = (i-1)*33
            local y = (j-1)*33
            local git = mapLayer:getTileGIDAt(self:convertPoint(x,y))
            if git >0 then
                -- 传送门数组添加
                local properties = self._map:getPropertiesForGID(git)
                if type(properties) == "table" then
                    local state = properties.state
                    if state ~= nil  and state == "3" then
                        table.insert(self._csmArray,cc.p(x,y))
                    end
                end
            end
        end
    end
end
-- 遍历tilemap的二位数组，转成一个全是空白区的一维数组，然后返回一个随机空白点
function GameMap:getNextFoodPosition()
    local idleArray = {}
    local mapLayer= self:getMap():getLayer("group1")
    local vec = mapLayer:getLayerSize ();
    local width = 25;
--    print(vec.width,vec.height)
    for i=1,width,1 do
            for j=1,vec.height,1 do
                local x = (i-1)*33
                local y = (j-1)*33
                local git = mapLayer:getTileGIDAt(self:convertPoint(x,y))
                if git == 0 then -- 找空白
                     table.insert(idleArray,cc.p(x,y))

                elseif git == 6 then
                    print (git)
                     -- 传送门数组添加
                    local properties = self._map:getPropertiesForGID(git)
                    if type(properties) == "table" then
                        local state = properties.state
                        if state=="3" then
                            print (state)
                        end
                        if state ~= nil  and state == "2" then
                            table.insert(self._csmArray,cc.p(x,y))
                        end
                    end
                end

            end
    end

    local point = idleArray[math.random(#idleArray)];
    return  point.x,point.y
end
-- 取得地图里面的传送门数组
function GameMap:getCsmArray()
    return self._csmArray
end
function GameMap:generateFood()
    local map_layer = self._map:getLayer("group1")
    if self._food~= nil then
        local x ,y = self._food:getPosition()
        map_layer:setTileGID(0,self:convertPoint(x,y))
        self._map:removeChild(self._food)

    end
    local x,y = self:getNextFoodPosition();
    self._food = display.newSprite("food.png")
    :setPosition(x,y)
    :setAnchorPoint(0,0)
    :setTag(100)
    :addTo(self._map)

    local git = 6 -- tilemap 里面state=2 的index
    map_layer:setTileGID(git,self:convertPoint(x,y))


end

function GameMap:addSnake(snake)
    self._snake = snake;
    snake:setGameMap(self);

    self:generateFood()

    return self;
end

function GameMap:getMap()
    return self._map;
end

function GameMap:gameOver()
    self._gameOver:gameOver(self)

    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    function onTimer(dt)
        scheduler.unscheduleGlobal(self._handle )
        local nextScene = require("app.scenes.TitleScene").new();
        display.replaceScene(nextScene,"fade",0.6,display.COLOR_WHITE);

    end
    self._handle = scheduler.scheduleGlobal(onTimer, 2.0, false)
end

return GameMap