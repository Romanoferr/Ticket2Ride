local mainMenuFunctions = {

}

-- funcoes de load

local function create_button(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function mainMenuFunctions.loadButtons(tab, button_values)

    for _, row in ipairs(button_values) do
        table.insert(tab, create_button(row[1], row[2]))
    end
end

function mainMenuFunctions.loadBackgroundFrames(frameCount, frames)

    for i = 1, frameCount do
        frames[i] = love.graphics.newImage(string.format("assets/steam_train_frames/frame%03d.png", i))
    end
end

function mainMenuFunctions.loadTitle(path)
    title = love.graphics.newImage(path)
    titleW = title:getWidth()
    titleH = title:getHeight()

    return title, titleW, titleH
end

return mainMenuFunctions