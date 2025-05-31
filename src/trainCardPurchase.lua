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

-- Função para mostrar mensagem temporária
local function showMessage(text, duration)
    gameState.message = text
    gameState.messageTimer = duration or 2.0
end

-- Inicializar cartas viradas para cima
local function initializeFaceUpCards()
    gameState.faceUpCards = {}
    for i = 1, 5 do
        if trainCards.getDeckSize() > 0 then
            table.insert(gameState.faceUpCards, trainCards.drawCard())
        end
    end
    lovebird.print("Face-up cards initialized: " .. #gameState.faceUpCards)
end

-- Função principal de inicialização
function trainCardPurchase.load()
    initializeFaceUpCards()
    showMessage("Vez do Jogador " .. gameState.currentPlayer, 2)
end

-- Atualização básica do timer de mensagens
function trainCardPurchase.update(dt)
    if gameState.messageTimer > 0 then
        gameState.messageTimer = gameState.messageTimer - dt
        if gameState.messageTimer <= 0 then
            gameState.message = ""
        end
    end
end
-- Substituir uma carta virada para cima
local function replaceFaceUpCard(index)
    if trainCards.getDeckSize() > 0 then
        gameState.faceUpCards[index] = trainCards.drawCard()
        lovebird.print("Replaced face-up card at position " .. index)
    else
        -- Se acabaram as cartas do deck, remove a carta
        table.remove(gameState.faceUpCards, index)
        lovebird.print("No more cards in deck, removed face-up card")
    end
end

-- Verificar se há muitas locomotivas nas cartas viradas
local function checkTooManyLocomotives()
    local locomotiveCount = 0
    for _, card in ipairs(gameState.faceUpCards) do
        if card == "JOKER" then
            locomotiveCount = locomotiveCount + 1
        end
    end
    
    -- Se há 3 ou mais locomotivas, embaralha de volta
    if locomotiveCount >= 3 then
        lovebird.print("Too many locomotives, reshuffling face-up cards")
        -- Coloca as cartas de volta no deck (simplificado)
        for _, card in ipairs(gameState.faceUpCards) do
            -- Em um jogo real, reembarcaria no deck
        end
        initializeFaceUpCards()
        return true
    end
    return false
end
return trainCardPurchase