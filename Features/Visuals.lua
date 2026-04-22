--[[
    TiooHub V2.1 — Visuals Module
    Tab    : Combat
    Author : Tiooprime2
]]

local Players   = game:GetService("Players")
local RepStore  = game:GetService("ReplicatedStorage")
local RunSvc    = game:GetService("RunService")
local player    = Players.LocalPlayer

local CONFIG = {
    KEN_INTERVAL  = 2,
    ESP_TAG       = "TiooESP_V2",
    UPDATE_RATE   = 0.5,
}

local kenEnabled = false
local espEnabled = false
local _kenThread = nil
local _espThread = nil
local _conns     = {}

-- ════ KEN ════
local function startKen()
    if _kenThread then return end
    _kenThread = task.spawn(function()
        local ok, remote = pcall(function()
            return RepStore:WaitForChild("Remotes", 5):WaitForChild("CommE", 5)
        end)
        if not ok then _kenThread = nil return end
        while kenEnabled do
            pcall(function() remote:FireServer("Ken", true) end)
            task.wait(CONFIG.KEN_INTERVAL)
        end
        _kenThread = nil
    end)
end

local function stopKen()
    kenEnabled = false
end

-- ════ ESP HELPERS ════
local function getToolName(char)
    local tool = char:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "None"
end

local function getHPPercent(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.MaxHealth <= 0 then return 0 end
    return math.floor((hum.Health / hum.MaxHealth) * 100)
end

local function buildBillboard(char)
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild(CONFIG.ESP_TAG)
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name            = CONFIG.ESP_TAG
    bb.Size            = UDim2.new(0, 160, 0, 44)
    bb.StudsOffset     = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop     = true
    bb.ResetOnSpawn    = false
    bb.Parent          = head

    local lbl = Instance.new("TextLabel")
    lbl.Name               = "Info"
    lbl.Size               = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3         = Color3.fromRGB(240, 238, 250)
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 11
    lbl.TextStrokeTransparency = 0.4
    lbl.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
    lbl.Parent             = bb
    return lbl
end

local function startESPLoop()
    if _espThread then return end
    _espThread = task.spawn(function()
        while espEnabled do
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local bb  = head:FindFirstChild(CONFIG.ESP_TAG)
                        local lbl = bb and bb:FindFirstChild("Info")
                        if lbl then
                            lbl.Text = string.format("%s\n%d%%  |  %s",
                                p.Name, getHPPercent(p.Character), getToolName(p.Character))
                        end
                    end
                end
            end
            task.wait(CONFIG.UPDATE_RATE)
        end
        _espThread = nil
    end)
end

local function cleanupESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local bb = head:FindFirstChild(CONFIG.ESP_TAG)
                if bb then bb:Destroy() end
            end
        end
    end
end

local function disconnectAll()
    for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
    table.clear(_conns)
end

local function attachESP(targetPlayer)
    if targetPlayer == player then return end
    local function onChar(char)
        if not espEnabled then return end
        task.spawn(function()
            local head = char:WaitForChild("Head", 5)
            if not head then return end
            buildBillboard(char)
        end)
    end
    local conn = targetPlayer.CharacterAdded:Connect(onChar)
    table.insert(_conns, conn)
    if targetPlayer.Character then onChar(targetPlayer.Character) end
end

local function attachAllESP()
    for _, p in ipairs(Players:GetPlayers()) do attachESP(p) end
    local conn = Players.PlayerAdded:Connect(attachESP)
    table.insert(_conns, conn)
end

-- ════ BUILD ════
local Visuals = {}

function Visuals.build(page, UI)
    UI.createSection(page, "Visuals")

    UI.createToggle(
        page,
        "Ken Visual",
        "Aktifkan efek mata Ken setiap 2 detik",
        false,
        function(state)
            kenEnabled = state
            if state then startKen() else stopKen() end
        end
    )

    UI.createToggle(
        page,
        "Player ESP",
        "Nama | HP% | Tool di atas kepala semua player",
        false,
        function(state)
            espEnabled = state
            if state then
                attachAllESP()
                startESPLoop()
            else
                disconnectAll()
                cleanupESP()
            end
        end
    )
end

return Visuals
