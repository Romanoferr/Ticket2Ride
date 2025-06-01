local destinationTicketCards = {}

local deck = {}

-- Load tickets from a CSV file into the deck
local function initializeDeck()
    local file = love.filesystem.newFile("src/assets/tickets.csv", "r")
    if not file then
        error("Failed to open tickets.csv")
    end

    for line in file:lines() do
        local fields = {}
        for field in line:gmatch("[^,]+") do
            table.insert(fields, field)
        end

        local ticket = {
            startCity = fields[1],
            endCity = fields[2],
            points = tonumber(fields[3])
        }
        table.insert(deck, ticket)
    end

    file:close()
end

-- Shuffle the deck
local function shuffleDeck()
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function destinationTicketCards.load()
    initializeDeck()
    shuffleDeck()
end

function destinationTicketCards.update(dt)
    -- Update any game state related to destination tickets if needed
end

function destinationTicketCards.draw()
    
end

function destinationTicketCards.drawCard()
    if #deck == 0 then
        error("No more cards in the deck!")
    end
    return table.remove(deck)
end

function destinationTicketCards.getDeckSize()
    return #deck
end

return destinationTicketCards
