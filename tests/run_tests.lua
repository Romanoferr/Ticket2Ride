local function run_tests()
    local test = require("test_main")
    local success = true
    local test_count = 0
    local passed_count = 0

    print("Running tests...")
    print("----------------")

    for name, func in pairs(test) do
        if type(func) == "function" and name:match("^test_") then
            test_count = test_count + 1
            local status, result = pcall(func)
            
            if status and result then
                print(string.format("✓ %s passed", name))
                passed_count = passed_count + 1
            else
                print(string.format("✗ %s failed", name))
                if not status then
                    print("  Error: " .. tostring(result))
                end
                success = false
            end
        end
    end

    print("----------------")
    print(string.format("Tests completed: %d/%d passed", passed_count, test_count))
    
    if not success then
        os.exit(1)
    end
end

run_tests() 