local TitleScene = class("TitleScene",function()
    return display.newScene()
end)

function TitleScene:addButton(img,px,py,callback)
    cc.ui.UIPushButton.new(img,img)
    :setPosition(px,py)
    :onButtonClicked(function(event)
        callback(event)
    end)
    :addTo(self)
end

function TitleScene:onEnter()

    local bg = display.newSprite("bg.png")
    bg:setPosition(display.cx,display.cy)
    bg:addTo(self)

    self:addButton('start.png',display.cx,display.cy/2,function(event)
        local mainScene = require("app.scenes.MainScene").new();
        display.replaceScene(mainScene,"fade",0.6,display.COLOR_WHITE);
    end)
    self:addButton('setting.png',display.cx-200,display.cy/4,function()end)
    self:addButton('question.png',display.cx,display.cy/4,function()end)
    self:addButton('exit.png',display.cx+200,display.cy/4,function(event)
        os.exit()
    end)
end

return TitleScene