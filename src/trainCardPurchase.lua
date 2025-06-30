
local trainCards = require "trainCards"
local players = require "players"
local lovebird = require "libs.lovebird"

local trainCardPurchase = {}

-- Estado do sistema de compra
local gameState = {
    currentPlayerId = nil,
    currentPlayer = nil,
    totalPlayers = nil,
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
    gameState.currentPlayerId = players.getCurrent().id
    gameState.currentPlayer = players.getCurrent()
    gameState.totalPlayers = players.total()
    initializeFaceUpCards()
    showMessage("Vez do Jogador " .. gameState.currentPlayerId, 2)
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
    players.assignTrainCards(gameState.currentPlayerId, {card})
    gameState.cardsDrawnThisTurn = gameState.cardsDrawnThisTurn + 1
    
    local cardName = trainCards.colorMap[card] or card
    showMessage("Comprou " .. cardName .. " do deck", 1.5)
    lovebird.print("Player " .. gameState.currentPlayerId .. " drew " .. cardName .. " from deck")
    
    return true
end

-- Comprar carta virada para cima
local function buyFaceUpCard(index)
    if index < 1 or index > #gameState.faceUpCards then
        return false
    end
    
    local card = gameState.faceUpCards[index]
    players.assignTrainCards(gameState.currentPlayerId, {card})
    
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
    
    lovebird.print("Player " .. gameState.currentPlayerId .. " bought face-up card: " .. (trainCards.colorMap[card] or card))
    return true
end

-- Verificar se pode comprar mais cartas
local function canDrawMore()
    return gameState.cardsDrawnThisTurn < gameState.maxCardsPerTurn and not gameState.turnEnded
end

-- Próximo jogador
local function nextPlayer(forced)
    local next = forced or players.next()
    gameState.currentPlayerId = next.id
    gameState.currentPlayer = next
    gameState.cardsDrawnThisTurn = 0
    gameState.turnEnded = false
    showMessage("Vez do Jogador " .. gameState.currentPlayerId, 1.5)
    lovebird.print("Next player: " .. gameState.currentPlayerId)

    players.resetConquerRouteStatus()
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

-- Renderização
function trainCardPurchase.draw()
    love.graphics.setColor(1, 1, 1)
    
    -- Título
    love.graphics.print("COMPRA DE CARTAS DE TREM", 20, 20, 0, 1.5, 1.5)
    
    -- Informações do turno atual
    love.graphics.print("Jogador Atual: " .. gameState.currentPlayerId, 20, 60)
    love.graphics.print("Cartas compradas neste turno: " .. gameState.cardsDrawnThisTurn .. "/" .. gameState.maxCardsPerTurn, 20, 80)
    
    if canDrawMore() then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("Pode comprar mais cartas", 20, 100)
    else
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Turno finalizado", 20, 100)
    end
    
    -- Deck
    love.graphics.setColor(0.4, 0.4, 0.7)
    love.graphics.rectangle("fill", 50, 150, 100, 140)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 50, 150, 100, 140)
    love.graphics.print("DECK", 75, 190)
    love.graphics.print("(" .. trainCards.getDeckSize() .. ")", 80, 210)
    love.graphics.print("Clique para", 60, 240)
    love.graphics.print("comprar", 70, 255)
    
    -- Cartas viradas para cima
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("CARTAS VIRADAS:", 200, 130)
    
    for i, card in ipairs(gameState.faceUpCards) do
        local x = 200 + (i - 1) * 120
        local y = 150
        
        -- Cor da carta
        local color = colors[card] or {0.5, 0.5, 0.5}
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x, y, 100, 140)
        
        -- Borda
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", x, y, 100, 140)
        
        -- Nome da carta
        love.graphics.setColor(0, 0, 0)
        local cardName = trainCards.colorMap[card] or card
        if card == "JOKER" then
            love.graphics.print("LOCO-", x + 25, y + 60)  
            love.graphics.print("MOTIVA", x + 20, y + 75)
        else
            love.graphics.print(cardName, x + 10, y + 65)
        end
        
        -- Número da carta para clique
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(i, x + 5, y + 5)
    end
    
    -- Instruções
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("INSTRUÇÕES:", 20, 320)
    love.graphics.print("• Clique no DECK para comprar carta aleatória", 20, 340)
    love.graphics.print("• Clique nas CARTAS VIRADAS (1-5) para escolher", 20, 360)
    love.graphics.print("• Máximo 2 cartas por turno", 20, 380)
    love.graphics.print("• Locomotiva termina o turno imediatamente", 20, 400)
    love.graphics.print("• Pressione SPACE para passar o turno", 20, 420)
    
    -- Cartas dos jogadores (resumido)
    local startY = 450
    for i = 1, gameState.totalPlayers do
        local playerCards = players.getTrainCards(i)
        local cardCount = #playerCards
        
        if i == gameState.currentPlayerId then
            love.graphics.setColor(1, 1, 0) -- Destaque jogador atual
        else
            love.graphics.setColor(0.7, 0.7, 0.7)
        end
        
        love.graphics.print("Jogador " .. i .. ": " .. cardCount .. " cartas", 20, startY + (i-1) * 20)
    end
    
    -- Mensagem temporária
    if gameState.message ~= "" then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(gameState.message, 400, 50, 0, 1.2, 1.2)
    end
end

-- Tratamento de cliques
function trainCardPurchase.mousepressed(x, y, button)
    if button ~= 1 or not canDrawMore() then -- Só clique esquerdo e se pode comprar
        return
    end

    gameState.currentPlayer.canConquerRoute = false
    
    -- Clique no deck
    if x >= 50 and x <= 150 and y >= 150 and y <= 290 then
        buyFromDeck()
        return
    end
    
    -- Clique nas cartas viradas
    for i = 1, #gameState.faceUpCards do
        local cardX = 200 + (i - 1) * 120
        local cardY = 150
        if x >= cardX and x <= cardX + 100 and y >= cardY and y <= cardY + 140 then
            buyFaceUpCard(i)
            return
        end
    end
end

-- Tratamento de teclas
function trainCardPurchase.keypressed(key)
    if key == "space" then
        -- Pular turno (apenas se já comprou pelo menos uma carta ou quer passar)
        if gameState.cardsDrawnThisTurn > 0 or not canDrawMore() then
            nextPlayer()
        else
            showMessage("Compre pelo menos uma carta ou pressione novamente para passar", 2)
        end
    end
    
    -- Teclas numéricas para cartas viradas
    local num = tonumber(key)
    if num and num >= 1 and num <= 5 and canDrawMore() then
        buyFaceUpCard(num)
    end
end

-- Obter estado atual (para integração)
function trainCardPurchase.getCurrentPlayerId()
    return gameState.currentPlayerId
end

function trainCardPurchase.canDrawCards()
    return canDrawMore()
end

function trainCardPurchase.getCardsDrawnThisTurn()
    return gameState.cardsDrawnThisTurn
end

function trainCardPurchase.updateState()
    -- Pega jogador atual atualizado, caso em que o jogador passa a vez comprando uma rota
    updatedPlayer = players.getCurrent()

    if gameState.currentPlayerId ~= updatedPlayer.id then
        nextPlayer(updatedPlayer)
    end
end

return trainCardPurchase