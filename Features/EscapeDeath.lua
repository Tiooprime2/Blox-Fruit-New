--[[
    TiooHub V2.1 — Escape Death Module
    Tab    : Combat
    Author : Tiooprime2
]]

local Players  = game:GetService("Players")
local UIS      = game:GetService("UserInputService")
local player   = Players.LocalPlayer

-- ════════════════════════════════════════════
--  CONFIG
-- ════════════════════════════════════════════
local CONFIG = {
    TIER1_HP     = 3000,
    TIER2_HP     = 1200,
    TIER1_HEIGHT = 5000,
    TIER2_HEIGHT = 12000,
    COOLDOWN     = 6,
    TOGGLE_KEY   = Enum.KeyCode.F9,
}

-- ════════════════════════════════════════════
--  STATE
-- ════════════════════════════════════════════
local isEnabled   = false
local isCooling   = false
local connections = {}
local toggle      = nil   -- ref ke UI toggle

-- ════════════════════════════════════════════
--  COOLDOWN
-- ════════════════════════════════════════════
local function runCooldown()
    isCooling = true
    task.spawn(function()
        task.wait(CONFIG.COOLDOWN)
        isCooling = false
    end)
end

-- ════════════════════════════════════════════
--  ESCAPE LOGIC
-- ════════════════════════════════════════════
local function triggerEscape(rootPart, tier)
    if not rootPart or not rootPart.Parent then return end
    local pos    = rootPart.Position
    local height = (tier == 2) and CONFIG.TIER2_HEIGHT or CONFIG.TIER1_HEIGHT
    rootPart.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y + height, pos.Z))
    runCooldown()
end

-- ════════════════════════════════════════════
--  HEALTH WATCHER
-- ════════════════════════════════════════════
local function connectEscape(character)
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    table.clear(connections)

    local ok, humanoid = pcall(function()
        return character:WaitForChild("Humanoid", 5)
    end)
    local ok2, rootPart = pcall(function()
        return character:WaitForChild("HumanoidRootPart", 5)
    end)
    if not ok or not ok2 then return end

    local conn = humanoid.HealthChanged:Connect(function(hp)
        if not isEnabled then return end
        if isCooling     then return end
        if hp <= 0       then return end

        if hp <= CONFIG.TIER2_HP then
            triggerEscape(rootPart, 2)
        elseif hp <= CONFIG.TIER1_HP then
            triggerEscape(rootPart, 1)
        end
    end)

    table.insert(connections, conn)
end

-- ════════════════════════════════════════════
--  CHARACTER LIFECYCLE
-- ════════════════════════════════════════════
local function onCharacterAdded(character)
    isCooling = false
    task.spawn(function() connectEscape(character) end)
end

-- ════════════════════════════════════════════
--  KEYBIND (F9 = toggle)
-- ════════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode ~= CONFIG.TOGGLE_KEY then return end
    isEnabled = not isEnabled
    -- Sync UI toggle kalau sudah di-init
    if toggle then toggle.setState(isEnabled) end
end)

-- ════════════════════════════════════════════
--  INIT (dipanggil dari combat.lua)
-- ════════════════════════════════════════════
local EscapeDeath = {}

function EscapeDeath.build(page, UI)
    UI.createSection(page, "Auto Escape")

    toggle = UI.createToggle(
        page,
        "Escape Death",
        string.format("Warning <%d HP  |  Critical <%d HP  |  F9 toggle", CONFIG.TIER1_HP, CONFIG.TIER2_HP),
        false,
        function(state)
            isEnabled = state
        end
    )

    -- Pasang listener setelah build
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        task.spawn(function() connectEscape(player.Character) end)
    end
end

return EscapeDeath
