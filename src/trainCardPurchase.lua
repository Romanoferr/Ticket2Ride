-- trainCardPurchase.lua
local trainCards = require "trainCards"
local players = require "players"
local lovebird = require "libs.lovebird"

local trainCardPurchase = {}

-- Estado do sistema de compra
local gameState = {
    currentPlayer = 1,
    totalPlayers = 3,
    cardsDrawnThisTurn = 0,
    maxCardsPerTurn = 2,
    turnEnded = false,
    faceUpCards = {}, -- 5 cartas viradas para cima
    purchasePhase = true, -- se estamos na fase de compra de cartas
    message = "",
    messageTimer = 0
}

-- Cores para renderização
local colors = {
    R = {0.8, 0.2, 0.2}, -- Red
    B = {0.2, 0.2, 0.8}, -- Blue  
    G = {0.2, 0.8, 0.2}, -- Green
    Y = {0.8, 0.8, 0.2}, -- Yellow
    O = {0.8, 0.5, 0.2}, -- Orange
    P = {0.6, 0.2, 0.6}, -- Purple
    K = {0.3, 0.3, 0.3}, -- Black
    W = {0.9, 0.9, 0.9}, -- White
    JOKER = {0.9, 0.9, 0.1} -- Joker (locomotiva)
}

return trainCardPurchase