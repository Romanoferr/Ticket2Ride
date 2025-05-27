-- gameManager.lua

local mainMenu = require "main_menu.mainMenu"
local board = require "board"
local train = require "train"
local scoringBoard = require "scoringBoard"
local tickets = require "destinationTicketCards"
local trainCards = require "trainCards"
local setupGame = require "setupGame"
local players = require "players"

local gameManager = {
    score = 0,
    player = nil,
    -- add other game state variables if needed
}

function gameManager.load()
    -- player.load()
    mainMenu.load()
    board.load()
    train.load()
    scoringBoard.load()
    tickets.load()
    trainCards.load()
    setupGame.load()
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    --player.update(dt)
    mainMenu.update(dt)
    board.update(dt)
    train.update(dt)
    scoringBoard.update(dt)
    trainCards.update(dt)
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    -- player.draw()
    mainMenu.draw()
    board.draw()
    train.draw()
    scoringBoard.draw()
    tickets.draw()
    trainCards.draw()
    setupGame.draw()
    players.draw()    
    -- Additional game manager drawing logic if needed
end

return gameManager