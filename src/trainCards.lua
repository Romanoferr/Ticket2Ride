local lovebird = require "src.libs.lovebird" -- Debugging tool

local trainCards = {}

trainCards.colorMap = { -- Expose colorMap
    R = "Red",
    B = "Blue",
    G = "Green",
    Y = "Yellow",
    O = "Orange",
    P = "Purple",
    K = "Black",
    W = "White",
    JOKER = "Joker",
}

-- atributo para armazenar quantidade de carta por cor
local cardColorCount = 15

local deck = {}

-- Initialize the deck with 15 cards for each color
local function initializeDeck()
    for color, _ in pairs(trainCards.colorMap) do
        for i = 1, cardColorCount do
            table.insert(deck, color)
        end
    end
end

-- Shuffle the deck
local function shuffleDeck()
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function trainCards.load()
    initializeDeck()
    shuffleDeck()
    --[[

    drawnCard = trainCards.drawCard() -- Testando a função drawCard na inicialização
    lovebird.print(string.format("Drawn Card: %s", trainCards.colorMap[drawnCard])) -- Testando a função drawCard na inicialização
    for i, card in ipairs(deck) do
        lovebird.print(string.format("Card %d: %s", i, trainCards.colorMap[card]))
    end  
    lovebird.print("Deck Size: " .. #deck) -- Testando a função getDeckSize na inicialização
    ]]
end

function trainCards.update(dt)
    -- Update any game state related to train cards if needed
end

function trainCards.draw()
end

-- função para retornar uma carta do deck e removê-la
function trainCards.drawCard()
    if #deck == 0 then
        error("No more cards in the deck!")
    end
    return table.remove(deck)
end

-- função para verificar tamanho do deck restante
function trainCards.getDeckSize()
    return #deck
end

return trainCards
