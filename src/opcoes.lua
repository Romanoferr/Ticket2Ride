local gameManager

local opcoes = {

}

function opcoes.load()
    gameManager = require "gameManager"
end

function opcoes.draw()
    love.graphics.setBackgroundColor(0.6, 0.2, 0.1)
end

return opcoes