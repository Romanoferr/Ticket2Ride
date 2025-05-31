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

function gameManager.draw()
    -- Desenha o tabuleiro de fundo
    board.draw()
    
    --  Interface de compra sobreposta
    if gameManager.gamePhase == "purchase" and gameManager.showPurchaseInterface then
        -- Fundo semi-transparente
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        -- Sistema de compra
        trainCardPurchase.draw()
    else
        -- Interface normal do jogo
        train.draw()
        scoringBoard.draw()
        tickets.draw()
        trainCards.draw()
        setupGame.draw()
        players.draw()
    end
    
    -- Botão para alternar interface (canto superior direito)
    love.graphics.setColor(0.3, 0.3, 0.7)
    love.graphics.rectangle("fill", love.graphics.getWidth() - 180, 10, 170, 40)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", love.graphics.getWidth() - 180, 10, 170, 40)
    
    local buttonText = gameManager.showPurchaseInterface and "Ver Tabuleiro" or "Comprar Cartas"
    love.graphics.print(buttonText, love.graphics.getWidth() - 175, 25)
    
    -- Informações do jogador atual (sempre visível)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Fase: " .. gameManager.gamePhase, 10, love.graphics.getHeight() - 40)
    if gameManager.gamePhase == "purchase" then
        love.graphics.print("Jogador " .. trainCardPurchase.getCurrentPlayer() .. " - Compras: " .. 
                          trainCardPurchase.getCardsDrawnThisTurn() .. "/2", 10, love.graphics.getHeight() - 20)
    end
end
return gameManager