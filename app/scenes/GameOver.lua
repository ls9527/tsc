--
-- 游戏结束
--

local GameOver = class("GameOver")

function GameOver:ctor()

end

function GameOver:gameOver(scene)
    self._sprite = display.newSprite("GameOver.jpg")
    :setPosition(display.cx,display.cy)
    :addTo(scene)
end

return GameOver

