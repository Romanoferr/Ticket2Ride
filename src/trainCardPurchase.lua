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

-- Comprar carta do deck
local function buyFromDeck()
    if trainCards.getDeckSize() == 0 then
        showMessage("Deck vazio!", 2)
        return false
    end
    
    local card = trainCards.drawCard()
    players.assignTrainCards(gameState.currentPlayer, {card})
    gameState.cardsDrawnThisTurn = gameState.cardsDrawnThisTurn + 1
    
    local cardName = trainCards.colorMap[card] or card
    showMessage("Comprou " .. cardName .. " do deck", 1.5)
    lovebird.print("Player " .. gameState.currentPlayer .. " drew " .. cardName .. " from deck")
    
    return true
end

-- Comprar carta virada para cima
local function buyFaceUpCard(index)
    if index < 1 or index > #gameState.faceUpCards then
        return false
    end
    
    local card = gameState.faceUpCards[index]
    players.assignTrainCards(gameState.currentPlayer, {card})
    
    -- Se é locomotiva, termina o turno imediatamente
    if card == "JOKER" then
        gameState.cardsDrawnThisTurn = gameState.maxCardsPerTurn
        gameState.turnEnded = true
        showMessage("Locomotiva! Turno encerrado", 2)
        lovebird.print("Player drew locomotive, turn ended")
    else
        gameState.cardsDrawnThisTurn = gameState.cardsDrawnThisTurn + 1
        local cardName = trainCards.colorMap[card] or card
        showMessage("Comprou " .. cardName, 1.5)
    end
    
    -- Substitui a carta virada
    replaceFaceUpCard(index)
    checkTooManyLocomotives()
    
    lovebird.print("Player " .. gameState.currentPlayer .. " bought face-up card: " .. (trainCards.colorMap[card] or card))
    return true
end

-- Verificar se pode comprar mais cartas
local function canDrawMore()
    return gameState.cardsDrawnThisTurn < gameState.maxCardsPerTurn and not gameState.turnEnded
end

-- Próximo jogador
local function nextPlayer()
    gameState.currentPlayer = (gameState.currentPlayer % gameState.totalPlayers) + 1
    gameState.cardsDrawnThisTurn = 0
    gameState.turnEnded = false
    showMessage("Vez do Jogador " .. gameState.currentPlayer, 1.5)
    lovebird.print("Next player: " .. gameState.currentPlayer)
end

-- Atualizar a função update para incluir controle de turnos
function trainCardPurchase.update(dt)
    if gameState.messageTimer > 0 then
        gameState.messageTimer = gameState.messageTimer - dt
        if gameState.messageTimer <= 0 then
            gameState.message = ""
        end
    end
    
    -- Verifica se deve passar o turno automaticamente
    if not canDrawMore() and gameState.cardsDrawnThisTurn > 0 then
        if gameState.messageTimer <= 0 then -- Só passa depois da mensagem
            nextPlayer()
        end
    end
end
return trainCardPurchase