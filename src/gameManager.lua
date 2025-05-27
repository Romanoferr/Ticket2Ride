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
    mainMenu = { mainMenu },
    game = { board,
             train,
             scoringBoard,
             tickets,
             trainCards,
             setupGame,
             players }
}

function gameManager.load()
    -- player.load()
    for _, state in ipairs(states[gameManager.state]) do
        if state.load then
            state.load()
        end
    end
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    --player.update(dt)
    for _, state in ipairs(states[gameManager.state]) do
        if state.update then
            state.update()
        end
    end
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    -- player.draw()
    for _, state in ipairs(states[gameManager.state]) do
        if state.draw then
            state.draw()
        end
    end
    -- Additional game manager drawing logic if needed
end

function gameManager.changeState(state)
    if states[state] then
        gameManager.state = state
        gameManager.load()
    end
end

return gameManager