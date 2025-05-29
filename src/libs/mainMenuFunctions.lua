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

-- funcoes de update

function mainMenuFunctions.updateFrames(mainMenu, dt)
    mainMenu.frameTimer = mainMenu.frameTimer + dt

    if mainMenu.frameTimer >= mainMenu.frameDelay then
        mainMenu.frameTimer = mainMenu.frameTimer - mainMenu.frameDelay
        mainMenu.currentFrame = mainMenu.currentFrame % mainMenu.frameCount + 1
    end
end

-- funcoes de draw

function mainMenuFunctions.drawBackground(mainMenu, ww, wh)

    love.graphics.draw(mainMenu.frames[mainMenu.currentFrame],
            0,
            0,
            0,
            ww / mainMenu.frames[mainMenu.currentFrame]:getWidth(),
            wh / mainMenu.frames[mainMenu.currentFrame]:getHeight())
end

function mainMenuFunctions.drawTitle(title, ww, titleW)

    -- 0.75 por que a escala mexe com a centralizacao (0.75 foi um chute)
    titleX = (ww * 0.75) - (titleW * 0.5)
    titleY = 0

    love.graphics.draw(
            title,
            titleX,
            titleY,
            0,
            0.5,
            0.5
    )
end

function mainMenuFunctions.isHot(mx, my, bx, by, button_width, button_height)

    return mx > bx and mx < bx + button_width and my > by and my < by + button_height

end

function mainMenuFunctions.buttonActivation(hot, b)
    if hot and not b.last and b.now then
        b.fn()
    end
end

function mainMenuFunctions.buttonHighlight(hot, color)
    if hot then
        for i, c in ipairs({ 0.8, 0.8, 0.9, 1.0 }) do
            color[i] = c
        end
    end
end

return mainMenuFunctions