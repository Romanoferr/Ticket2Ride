-- gameManager.lua

local board = require "board"
local train = require "train"
local scoringBoard = require "scoringBoard"
local tickets = require "destinationTicketCards"
local trainCards = require "trainCards"

local gameManager = {
    score = 0,
    player = nil,
    -- add other game state variables if needed
}

function gameManager.load()
    -- player.load()
    board.load()
    train.load()
    scoringBoard.load()
    tickets.load()
    trainCards.load()
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    --player.update(dt)
    board.update(dt)
    train.update(dt)
    scoringBoard.update(dt)
    trainCards.update(dt)
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    -- player.draw()
    board.draw()
    train.draw()
    scoringBoard.draw()
    tickets.draw()
    trainCards.draw()
    -- Additional game manager drawing logic if needed
end

return gameManager