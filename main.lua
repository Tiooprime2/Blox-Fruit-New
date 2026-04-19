-- ╔══════════════════════════════════════════╗
-- ║       TIOOHUB V2.1 — MAIN LOADER         ║
-- ╚══════════════════════════════════════════╝

local BASE = "https://raw.githubusercontent.com/Tiooprime2/Blox-Fruit-New/refs/heads/main/"

local UI          = loadstring(game:HttpGet(BASE .. "SemuaUI/UI.lua"))()
local EscapeDeath = loadstring(game:HttpGet(BASE .. "Features/EscapeDeath.lua"))()

task.spawn(function()
    pcall(EscapeDeath.build, UI.combatPage, UI)
end)
