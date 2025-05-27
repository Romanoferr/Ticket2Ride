-- gameManager.lua

local mainMenu = require "mainMenu"
local board = require "board"
local train = require "train"
local scoringBoard = require "scoringBoard"
local tickets = require "destinationTicketCards"
local trainCards = require "trainCards"
local setupGame = require "setupGame"
local players = require "players"

local gameManager = {
    state = "mainMenu",
    score = 0,
    player = nil,
    -- add other game state variables if needed
}

local states = {
    mainMenu = mainMenu,
    board = board,
    train = train,
    scoringBoard = scoringBoard,
    tickets = tickets,
    trainCards = trainCards,
    setupGame = setupGame,
    players = players,
}

function gameManager.changeState(state)
    print(state)
    if states[state] then
        gameManager.state = state
        states[state].load()
    end
end

function gameManager.load()
    -- player.load()
    states[gameManager.state].load()
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    --player.update(dt)
    states[gameManager.state].update(dt)
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    -- player.draw()
    states[gameManager.state].draw()
    -- Additional game manager drawing logic if needed
end

return gameManager