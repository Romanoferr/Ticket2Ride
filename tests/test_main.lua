local test = {}

function test.test_main_menu_functions()
    local mainMenuFunctions = require("src.libs.mainMenuFunctions")
    
    -- Test if mainMenuFunctions table exists and has expected functions
    assert(mainMenuFunctions ~= nil, "mainMenuFunctions should not be nil")
    assert(type(mainMenuFunctions.loadButtons) == "function", "loadButtons should be a function")
    assert(type(mainMenuFunctions.loadBackgroundFrames) == "function", "loadBackgroundFrames should be a function")
    assert(type(mainMenuFunctions.loadTitle) == "function", "loadTitle should be a function")
    
    return true
end

function test.test_button_creation()
    local mainMenuFunctions = require("src.libs.mainMenuFunctions")
    
    -- Test button creation
    local button = mainMenuFunctions.create_button("Test Button", function() end)
    assert(button.text == "Test Button", "Button text should match")
    assert(type(button.fn) == "function", "Button function should be a function")
    
    return true
end

return test 