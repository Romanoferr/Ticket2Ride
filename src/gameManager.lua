local mainMenu = require "mainMenu"
local board = require "board"
local train = require "train"
local scoringBoard = require "scoringBoard"
local tickets = require "destinationTicketCards"
local trainCards = require "trainCards"
local setupGame = require "setupGame"
local players = require "players"
local trainCardPurchase = require "trainCardPurchase" 

local gameManager = {
    state = "mainMenu",
    score = 0,
    player = nil,
    gamePhase = "purchase", -- "purchase", "routes", "tickets", etc.
    showPurchaseInterface = true -- Controla se mostra a interface de compra
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
    -- Use generic state loading for flexibility
    for _, state in ipairs(states[gameManager.state]) do
        if state.load then
            state.load()
        end
    end
    
    -- Initialize train card purchase system when in game state
    if gameManager.state == "game" then
        trainCardPurchase.load()
    end
    
    -- Additional game manager initialization if needed
end

function gameManager.update(dt)
    -- Update all modules in current state
    for _, state in ipairs(states[gameManager.state]) do
        if state.update then
            state.update(dt)
        end
    end
    
    -- Update train card purchase system if in game and purchase phase
    if gameManager.state == "game" and gameManager.gamePhase == "purchase" then
        trainCardPurchase.update(dt)
    end
    
    -- Additional game manager update logic if needed
end

function gameManager.draw()
    if gameManager.state == "game" then
        -- Game-specific drawing logic
        -- Always draw the board as background
        board.draw()
        
        -- Interface de compra sobreposta
        if gameManager.gamePhase == "purchase" and gameManager.showPurchaseInterface then
            -- Fundo semi-transparente
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            
            -- Sistema de compra
            trainCardPurchase.draw()
        else
            -- Interface normal do jogo - draw other game components
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
    else
        -- Generic state drawing for non-game states (like main menu)
        for _, state in ipairs(states[gameManager.state]) do
            if state.draw then
                state.draw()
            end
        end
    end
    
    -- Additional game manager drawing logic if needed
end

-- Funções para tratar eventos
function gameManager.mousepressed(x, y, button)
    if gameManager.state == "game" then
        -- Verifica clique no botão de alternar interface
        if x >= love.graphics.getWidth() - 180 and x <= love.graphics.getWidth() - 10 and 
           y >= 10 and y <= 50 then
            gameManager.updateStates()
        end
        end
        
        -- Passa evento para o sistema de compra se estiver ativo
        if gameManager.gamePhase == "purchase" and gameManager.showPurchaseInterface then
            trainCardPurchase.mousepressed(x, y, button)
        end
    end
end

function gameManager.keypressed(key)
    if gameManager.state == "game" then
        -- Alterna entre fases do jogo
        if key == "tab" then
            gameManager.updateStates()
        end
        
        -- Passa evento para o sistema de compra se estiver ativo
        if gameManager.gamePhase == "purchase" and gameManager.showPurchaseInterface then
            trainCardPurchase.keypressed(key)
        end
    end
end

function gameManager.updateStates()
    if gameManager.gamePhase == "purchase" then
        gameManager.gamePhase = "routes"
        gameManager.showPurchaseInterface = false
        gameManager.showRouteConquestConfirm = false
    else
        gameManager.gamePhase = "purchase" 
        gameManager.showPurchaseInterface = true
    end
    return
end

function gameManager.changeState(state)
    if states[state] then
        gameManager.state = state
        gameManager.load()
    end
end

return gameManager