-- gameManager.lua - Atualizado com sistema de compra de cartas

local board = require "board"
local train = require "train"
local scoringBoard = require "scoringBoard"
local tickets = require "destinationTicketCards"
local trainCards = require "trainCards"
local setupGame = require "setupGame"
local players = require "players"
local trainCardPurchase = require "trainCardPurchase" -- NOVO: Sistema de compra

local gameManager = {
    score = 0,
    player = nil,
    gamePhase = "purchase", -- "purchase", "routes", "tickets", etc.
    showPurchaseInterface = true -- Controla se mostra a interface de compra
}

function gameManager.load()
    board.load()
    train.load()
    scoringBoard.load()
    tickets.load()
    trainCards.load()
    setupGame.load()
    trainCardPurchase.load() -- NOVO: Inicializa sistema de compra
end

function gameManager.update(dt)
    board.update(dt)
    train.update(dt)
    scoringBoard.update(dt)
    trainCards.update(dt)
    
    -- NOVO: Atualiza sistema de compra se estiver ativo
    if gameManager.gamePhase == "purchase" then
        trainCardPurchase.update(dt)
    end
end

return gameManager