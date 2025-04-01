-- gameManager.lua

-- local player = require "player"
local board = require "board"
-- local card = require "card"

local gameManager = {
    score = 0
}

function gameManager.load()
    -- player.load()
    board.load()
    -- card.load()
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    --player.update(dt)
    board.update(dt)
    -- card.update(dt)
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    -- player.draw()
    board.draw()
    -- card.draw()
    -- Additional game manager drawing logic if needed
end

return gameManager