
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)


function MainScene:ctor()



end

function MainScene:onEnter()

    display.addSpriteFrames("main.plist","main.png")
    local gameMap = require("app.core.GameMap").new();
    local snake = require("app.core.Snake").new(5,"top");
    gameMap:addSnake(snake):addTo(self)

end

function MainScene:onExit()
end

return MainScene
