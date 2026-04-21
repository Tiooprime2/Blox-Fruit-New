--[[
    TiooHub V2.1 — HighJump Module
    Tab    : Combat
    Author : Tiooprime2
]]

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local Debris  = game:GetService("Debris")
local RunSvc  = game:GetService("RunService")
local player  = Players.LocalPlayer

-- ════════════════════════════════════════════
--  CONFIG
-- ════════════════════════════════════════════
local CONFIG = {
    JUMP_POWER    = 150,
    INFINITE_JUMP = true,
    BV_DURATION   = 0.10,
    DEBOUNCE      = 0.08,
}

-- ════════════════════════════════════════════
--  STATE
-- ════════════════════════════════════════════
local isEnabled  = false
local _lockConn  = nil
local _jumpConn  = nil
local _lastJump  = 0
local toggle     = nil

-- ════════════════════════════════════════════
--  LOCK JUMPPOWER
-- ════════════════════════════════════════════
local function startLock(hum)
    if _lockConn then _lockConn:Disconnect() end

    _lockConn = RunSvc.Heartbeat:Connect(function()
        if not isEnabled then return end
        if hum and hum.Parent then
            if hum.JumpPower ~= CONFIG.JUMP_POWER then
                hum.JumpPower = CONFIG.JUMP_POWER
            end
        else
            _lockConn:Disconnect()
            _lockConn = nil
        end
    end)
end

-- ════════════════════════════════════════════
--  SMOOTH JUMP
-- ════════════════════════════════════════════
local function doJump(root, hum)
    local bv    = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, CONFIG.JUMP_POWER, 0)
    bv.Parent   = root
    Debris:AddItem(bv, CONFIG.BV_DURATION)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end

-- ════════════════════════════════════════════
--  INFINITE JUMP LISTENER
-- ════════════════════════════════════════════
local function startJump()
    if _jumpConn then _jumpConn:Disconnect() end

    _jumpConn = UIS.JumpRequest:Connect(function()
        if not isEnabled then return end

        local char = player.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if hum:GetState() == Enum.HumanoidStateType.Dead then return end

        local now = tick()
        if now - _lastJump < CONFIG.DEBOUNCE then return end

        local state    = hum:GetState()
        local onGround = state == Enum.HumanoidStateType.Landed
                      or state == Enum.HumanoidStateType.Running

        if CONFIG.INFINITE_JUMP or onGround then
            _lastJump = now
            doJump(root, hum)
        end
    end)
end

-- ════════════════════════════════════════════
--  RESET JUMPPOWER
-- ════════════════════════════════════════════
local function resetJump()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = 50 end  -- default Roblox
end

-- ════════════════════════════════════════════
--  CHARACTER LIFECYCLE
-- ════════════════════════════════════════════
local function onCharacterAdded(char)
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        if isEnabled then hum.JumpPower = CONFIG.JUMP_POWER end
        startLock(hum)
        startJump()
    end)
end

local function onCharacterRemoving()
    if _lockConn then _lockConn:Disconnect(); _lockConn = nil end
    if _jumpConn then _jumpConn:Disconnect(); _jumpConn = nil end
end

-- ════════════════════════════════════════════
--  INIT
-- ════════════════════════════════════════════
local HighJump = {}

function HighJump.build(page, UI)
    UI.createSection(page, "Movement")

    toggle = UI.createToggle(
        page,
        "High Jump",
        string.format("Power: %d  |  Infinite Jump: %s", CONFIG.JUMP_POWER, tostring(CONFIG.INFINITE_JUMP)),
        false,
        function(state)
            isEnabled = state
            if not state then
                resetJump()
            else
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.JumpPower = CONFIG.JUMP_POWER end
                end
            end
        end
    )

    player.CharacterAdded:Connect(onCharacterAdded)
    player.CharacterRemoving:Connect(onCharacterRemoving)

    if player.Character then
        task.spawn(function() onCharacterAdded(player.Character) end)
    end
end

return HighJump
