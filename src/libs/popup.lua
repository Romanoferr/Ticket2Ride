local popup = {}

-- Estado do pop-up
local isVisible = false
local message = ""
local button1Text = "Ok"
local button2Text = "Não"
local button1Callback = nil
local button2Callback = nil
local hasSecondButton = false  -- Variável para verificar se há segundo botão

-- Função para exibir o pop-up com a mensagem e callbacks para os botões
function popup.show(messageText, button1Text, button2Text, button1Action, button2Action)
    message = messageText
    button1Text = button1Text or "Ok"
    button2Text = button2Text or "Não"
    button1Callback = button1Action
    button2Callback = button2Action
    hasSecondButton = button2Text ~= nil and button2Action ~= nil -- Se não passar o segundo botão, usará só um botão
    isVisible = true
end

-- Função para esconder o pop-up
function popup.hide()
    isVisible = false
end

-- Função de atualização do pop-up (pode ser chamada dentro do update)
function popup.update(dt)
    -- Aqui você pode adicionar animações ou controles de tempo, se necessário
end

-- Função para desenhar o pop-up na tela
function popup.draw()
    if isVisible then
        local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

        -- Background do pop-up (transparente)
        love.graphics.setColor(0, 0, 0, 0.7)  -- Fundo escuro, parcialmente transparente
        love.graphics.rectangle("fill", ww * 0.25, wh * 0.3, ww * 0.5, wh * 0.3)
        
        -- Texto da mensagem
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(message, ww * 0.25, wh * 0.35, ww * 0.5, "center", 0, 1.5, 1.5)

        -- Botão 1
        local buttonWidth = 100
        local buttonHeight = 50
        local buttonMargin = 20

        -- Botão 1 (sempre visível)
        local button1X = ww * 0.35
        local button1Y = wh * 0.55
        love.graphics.setColor(0.2, 0.8, 0.2)  -- Verde
        love.graphics.rectangle("fill", button1X, button1Y, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(button1Text, button1X, button1Y + buttonHeight / 4, buttonWidth, "center")

        -- Botão 2 (apenas se estiver configurado)
        if hasSecondButton then
            local button2X = ww * 0.55
            local button2Y = wh * 0.55
            love.graphics.setColor(0.8, 0.2, 0.2)  -- Vermelho
            love.graphics.rectangle("fill", button2X, button2Y, buttonWidth, buttonHeight)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(button2Text, button2X, button2Y + buttonHeight / 4, buttonWidth, "center")
        end
    end
end

-- Função de tratamento de clique no pop-up
function popup.mousepressed(x, y, button)
    if button == 1 and isVisible then  -- Verifica se é clique esquerdo
        local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

        -- Botão 1
        local button1X = ww * 0.35
        local button1Y = wh * 0.55
        local buttonWidth = 100
        local buttonHeight = 50
        if x >= button1X and x <= button1X + buttonWidth and y >= button1Y and y <= button1Y + buttonHeight then
            if button1Callback then button1Callback() end
            popup.hide()
        end

        -- Botão 2 (caso exista)
        if hasSecondButton then
            local button2X = ww * 0.55
            local button2Y = wh * 0.55
            if x >= button2X and x <= button2X + buttonWidth and y >= button2Y and y <= button2Y + buttonHeight then
                if button2Callback then button2Callback() end
                popup.hide()
            end
        end
    end
end

return popup
