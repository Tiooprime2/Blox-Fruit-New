local BASE = "https://raw.githubusercontent.com/Tiooprime2/Blox-Fruit-New/refs/heads/main/"

local UI          = loadstring(game:HttpGet(BASE .. "SemuaUI/UI.lua"))()
local EscapeDeath = loadstring(game:HttpGet(BASE .. "Features/EscapeDeath.lua"))()
local HighJump    = loadstring(game:HttpGet(BASE .. "Features/HighJump.lua"))()
local Visuals     = loadstring(game:HttpGet(BASE .. "Features/Visuals.lua"))()

task.spawn(function() pcall(EscapeDeath.build, UI.combatPage, UI) end)
task.spawn(function() pcall(HighJump.build,    UI.combatPage, UI) end)
task.spawn(function() pcall(Visuals.build,     UI.combatPage, UI) end)
