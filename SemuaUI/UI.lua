-- ╔══════════════════════════════════════════╗
-- ║       TIOOHUB V2.1 — UI MODULE           ║
-- ║       Theme: Claude Minimal              ║
-- ╚══════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

if pGui:FindFirstChild("TiooHubV2") then pGui.TiooHubV2:Destroy() end

-- ═══════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════
local THEME = {
    BG_DARK      = Color3.fromRGB(12, 12, 16),
    BG_PANEL     = Color3.fromRGB(18, 18, 24),
    BG_CARD      = Color3.fromRGB(24, 24, 32),
    BG_HOVER     = Color3.fromRGB(32, 30, 46),
    BG_ACTIVE    = Color3.fromRGB(50, 40, 80),
    ACCENT       = Color3.fromRGB(160, 130, 255),
    ACCENT_DIM   = Color3.fromRGB(100, 80, 180),
    GREEN        = Color3.fromRGB(100, 220, 160),
    RED          = Color3.fromRGB(255, 90, 90),
    TEXT_PRIMARY = Color3.fromRGB(240, 238, 250),
    TEXT_MUTED   = Color3.fromRGB(130, 125, 155),
    BORDER       = Color3.fromRGB(45, 42, 62),
    SIDEBAR      = Color3.fromRGB(14, 14, 20),
}

-- ═══════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color or THEME.BORDER
    s.Thickness    = thickness or 1
    s.Transparency = transparency or 0
    s.Parent       = obj
    return s
end

local function tween(obj, t, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    )
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            tween(frame, 0.06, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            }):Play()
        end
    end)
end

-- ═══════════════════════════════════════════
-- MAIN GUI
-- ═══════════════════════════════════════════
local mainGui = Instance.new("ScreenGui")
mainGui.Name             = "TiooHubV2"
mainGui.ResetOnSpawn     = false
mainGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
mainGui.IgnoreGuiInset   = true
mainGui.Parent           = pGui

-- Wrapper: ClipsDescendants di sini supaya konten tidak bocor saat animasi tutup
local clipWrapper = Instance.new("Frame")
clipWrapper.Name                = "ClipWrapper"
clipWrapper.Size                = UDim2.new(0, 360, 0, 230)
clipWrapper.Position            = UDim2.new(0.5, -180, 0.5, -115)
clipWrapper.BackgroundTransparency = 1
clipWrapper.ClipsDescendants    = true   -- ROOT FIX sisa UI bocor
clipWrapper.BorderSizePixel     = 0
clipWrapper.Parent              = mainGui

local mainFrame = Instance.new("Frame")
mainFrame.Name              = "MainWindow"
mainFrame.Size              = UDim2.new(1, 0, 1, 0)
mainFrame.Position          = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3  = THEME.BG_DARK
mainFrame.BorderSizePixel   = 0
mainFrame.ClipsDescendants  = false
mainFrame.Parent            = clipWrapper
corner(mainFrame, 14)
stroke(mainFrame, THEME.BORDER, 1, 0)

-- Accent line top
local topLine = Instance.new("Frame")
topLine.Size             = UDim2.new(0.45, 0, 0, 2)
topLine.Position         = UDim2.new(0.275, 0, 0, 0)
topLine.BackgroundColor3 = THEME.ACCENT
topLine.BorderSizePixel  = 0
topLine.Parent           = mainFrame
corner(topLine, 2)

-- ═══════════════════════════════════════════
-- HEADER
-- ═══════════════════════════════════════════
local header = Instance.new("Frame")
header.Size             = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = THEME.BG_PANEL
header.BorderSizePixel  = 0
header.Parent           = mainFrame
corner(header, 14)

local headerFix = Instance.new("Frame")
headerFix.Size             = UDim2.new(1, 0, 0, 10)
headerFix.Position         = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = THEME.BG_PANEL
headerFix.BorderSizePixel  = 0
headerFix.Parent           = header

local logoBadge = Instance.new("Frame")
logoBadge.Size             = UDim2.new(0, 20, 0, 20)
logoBadge.Position         = UDim2.new(0, 8, 0.5, -10)
logoBadge.BackgroundColor3 = THEME.ACCENT_DIM
logoBadge.BorderSizePixel  = 0
logoBadge.Parent           = header
corner(logoBadge, 6)

local logoT = Instance.new("TextLabel")
logoT.Size               = UDim2.new(1, 0, 1, 0)
logoT.BackgroundTransparency = 1
logoT.Text               = "T"
logoT.TextColor3         = THEME.TEXT_PRIMARY
logoT.Font               = Enum.Font.GothamBold
logoT.TextSize           = 11
logoT.Parent             = logoBadge

local titleLbl = Instance.new("TextLabel")
titleLbl.Size               = UDim2.new(1, -110, 0, 14)
titleLbl.Position           = UDim2.new(0, 34, 0, 5)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "TiooHub V2.1"
titleLbl.TextColor3         = THEME.TEXT_PRIMARY
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.TextSize           = 9
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.Parent             = header

local subLbl = Instance.new("TextLabel")
subLbl.Size               = UDim2.new(1, -110, 0, 10)
subLbl.Position           = UDim2.new(0, 34, 0, 19)
subLbl.BackgroundTransparency = 1
subLbl.Text               = "Blox Fruit  •  by Tiooprime2"
subLbl.TextColor3         = THEME.TEXT_MUTED
subLbl.Font               = Enum.Font.Gotham
subLbl.TextSize           = 7
subLbl.TextXAlignment     = Enum.TextXAlignment.Left
subLbl.Parent             = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size             = UDim2.new(0, 20, 0, 20)
closeBtn.Position         = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
closeBtn.Text             = "✕"
closeBtn.TextColor3       = THEME.RED
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 9
closeBtn.BorderSizePixel  = 0
closeBtn.Parent           = header
corner(closeBtn, 6)
stroke(closeBtn, THEME.RED, 1, 0.6)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = THEME.RED, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(40,20,30), TextColor3 = THEME.RED}):Play()
end)

makeDraggable(clipWrapper, header)

-- ═══════════════════════════════════════════
-- BODY
-- ═══════════════════════════════════════════
local body = Instance.new("Frame")
body.Size               = UDim2.new(1, -10, 1, -40)
body.Position           = UDim2.new(0, 5, 0, 36)
body.BackgroundTransparency = 1
body.Parent             = mainFrame

local sidebar = Instance.new("Frame")
sidebar.Size             = UDim2.new(0, 70, 1, 0)
sidebar.BackgroundColor3 = THEME.SIDEBAR
sidebar.BorderSizePixel  = 0
sidebar.Parent           = body
corner(sidebar, 10)
stroke(sidebar, THEME.BORDER, 1, 0.5)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 3)
sideLayout.Parent  = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop    = UDim.new(0, 5)
sidePad.PaddingBottom = UDim.new(0, 5)
sidePad.PaddingLeft   = UDim.new(0, 4)
sidePad.PaddingRight  = UDim.new(0, 4)
sidePad.Parent        = sidebar

local contentPanel = Instance.new("Frame")
contentPanel.Size             = UDim2.new(1, -76, 1, 0)
contentPanel.Position         = UDim2.new(0, 76, 0, 0)
contentPanel.BackgroundColor3 = THEME.BG_PANEL
contentPanel.BorderSizePixel  = 0
contentPanel.ClipsDescendants = true
contentPanel.Parent           = body
corner(contentPanel, 10)
stroke(contentPanel, THEME.BORDER, 1, 0.5)

local pageTitle = Instance.new("TextLabel")
pageTitle.Size               = UDim2.new(1, -10, 0, 22)
pageTitle.Position           = UDim2.new(0, 8, 0, 4)
pageTitle.BackgroundTransparency = 1
pageTitle.Text               = "Main"
pageTitle.TextColor3         = THEME.ACCENT
pageTitle.Font               = Enum.Font.GothamBold
pageTitle.TextSize           = 10
pageTitle.TextXAlignment     = Enum.TextXAlignment.Left
pageTitle.Parent             = contentPanel

local divider = Instance.new("Frame")
divider.Size             = UDim2.new(1, -10, 0, 1)
divider.Position         = UDim2.new(0, 5, 0, 26)
divider.BackgroundColor3 = THEME.BORDER
divider.BorderSizePixel  = 0
divider.Parent           = contentPanel

-- ═══════════════════════════════════════════
-- PAGES
-- ═══════════════════════════════════════════
local pages     = {}
local activeTab = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size                  = UDim2.new(1, -8, 1, -32)
    page.Position              = UDim2.new(0, 4, 0, 30)
    page.BackgroundTransparency = 1
    page.BorderSizePixel       = 0
    page.ScrollBarThickness    = 2
    page.ScrollBarImageColor3  = THEME.ACCENT
    page.CanvasSize            = UDim2.new(0, 0, 0, 0)
    page.Visible               = false
    page.Parent                = contentPanel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent  = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop   = UDim.new(0, 4)
    pad.PaddingLeft  = UDim.new(0, 3)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent       = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)

    pages[name] = page
    return page
end

local function switchTab(name, tabBtn, icon)
    for _, p in pairs(pages) do p.Visible = false end
    if pages[name] then pages[name].Visible = true end
    pageTitle.Text = icon .. "  " .. name

    for _, child in pairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1
            local lbl = child:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = THEME.TEXT_MUTED end
        end
    end

    if tabBtn then
        tabBtn.BackgroundTransparency = 0
        tween(tabBtn, 0.15, {BackgroundColor3 = THEME.BG_ACTIVE}):Play()
        local lbl = tabBtn:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.TextColor3 = THEME.ACCENT end
    end
    activeTab = name
end

local function createTab(icon, name)
    createPage(name)

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 0, 26)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3     = THEME.BG_ACTIVE
    btn.Text                 = ""
    btn.BorderSizePixel      = 0
    btn.Parent               = sidebar
    corner(btn, 8)

    local iconL = Instance.new("TextLabel")
    iconL.Size               = UDim2.new(0, 18, 1, 0)
    iconL.Position           = UDim2.new(0, 3, 0, 0)
    iconL.BackgroundTransparency = 1
    iconL.Text               = icon
    iconL.TextSize           = 12
    iconL.Font               = Enum.Font.GothamBold
    iconL.Parent             = btn

    local nameL = Instance.new("TextLabel")
    nameL.Size               = UDim2.new(1, -24, 1, 0)
    nameL.Position           = UDim2.new(0, 23, 0, 0)
    nameL.BackgroundTransparency = 1
    nameL.Text               = name
    nameL.TextColor3         = THEME.TEXT_MUTED
    nameL.Font               = Enum.Font.GothamSemibold
    nameL.TextSize           = 7
    nameL.TextXAlignment     = Enum.TextXAlignment.Left
    nameL.Parent             = btn

    btn.MouseButton1Click:Connect(function() switchTab(name, btn, icon) end)
    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.1, {BackgroundTransparency = 0, BackgroundColor3 = THEME.BG_HOVER}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then tween(btn, 0.1, {BackgroundTransparency = 1}):Play() end
    end)

    return btn, pages[name]
end

-- ═══════════════════════════════════════════
-- TABS
-- ═══════════════════════════════════════════
local mainTabBtn,   mainPage   = createTab("🏠", "Main")
local combatTabBtn, combatPage = createTab("⚔️", "Combat")
local farmTabBtn,   farmPage   = createTab("🌾", "Farm")
local miscTabBtn,   miscPage   = createTab("⚙️", "Misc")

switchTab("Main", mainTabBtn, "🏠")

-- ═══════════════════════════════════════════
-- OPEN BUTTON
-- ═══════════════════════════════════════════
local openBtn = Instance.new("TextButton")
openBtn.Size             = UDim2.new(0, 44, 0, 44)
openBtn.Position         = UDim2.new(0.02, 0, 0.45, 0)
openBtn.BackgroundColor3 = THEME.BG_DARK
openBtn.Text             = "T"
openBtn.TextColor3       = THEME.ACCENT
openBtn.Font             = Enum.Font.GothamBold
openBtn.TextSize         = 20
openBtn.Visible          = false
openBtn.BorderSizePixel  = 0
openBtn.Parent           = mainGui
corner(openBtn, 12)
stroke(openBtn, THEME.ACCENT, 2, 0.4)
makeDraggable(openBtn)

-- ═══════════════════════════════════════════
-- OPEN / CLOSE — SMOOTH + NO BLEED
-- ═══════════════════════════════════════════
local isOpen        = true
local closeListeners = {}
local animLock      = false

local function onClose(fn) table.insert(closeListeners, fn) end

local function closeUI()
    if animLock then return end
    animLock = true
    isOpen   = false
    for _, fn in pairs(closeListeners) do pcall(fn) end

    -- Kecilkan clipWrapper (bukan mainFrame) → konten ter-clip rapi
    tween(clipWrapper, 0.25, {
        Size     = UDim2.new(0, 360, 0, 0),
        Position = UDim2.new(0.5, -180, 0.5, 0),
    }):Play()

    task.delay(0.26, function()
        clipWrapper.Visible = false
        openBtn.Visible     = true
        animLock            = false
    end)
end

local function openUI()
    if animLock then return end
    animLock            = true
    isOpen              = true
    clipWrapper.Visible = true
    openBtn.Visible     = false

    clipWrapper.Size     = UDim2.new(0, 360, 0, 0)
    clipWrapper.Position = UDim2.new(0.5, -180, 0.5, 0)

    tween(clipWrapper, 0.3, {
        Size     = UDim2.new(0, 360, 0, 230),
        Position = UDim2.new(0.5, -180, 0.5, -115),
    }):Play()

    task.delay(0.31, function() animLock = false end)
end

closeBtn.MouseButton1Click:Connect(closeUI)
openBtn.MouseButton1Click:Connect(openUI)

-- Intro animation
clipWrapper.Size     = UDim2.new(0, 360, 0, 0)
clipWrapper.Position = UDim2.new(0.5, -180, 0.5, 0)
tween(clipWrapper, 0.35, {
    Size     = UDim2.new(0, 360, 0, 230),
    Position = UDim2.new(0.5, -180, 0.5, -115),
}):Play()

-- ═══════════════════════════════════════════
-- TOGGLE BUILDER
-- ═══════════════════════════════════════════
local function createToggle(page, name, desc, defaultState, callback)
    local state = defaultState or false

    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = state and Color3.fromRGB(30, 22, 50) or THEME.BG_CARD
    row.BorderSizePixel  = 0
    row.Parent           = page
    corner(row, 8)

    local nameL = Instance.new("TextLabel")
    nameL.Size               = UDim2.new(1, -52, 0, 14)
    nameL.Position           = UDim2.new(0, 8, 0, 7)
    nameL.BackgroundTransparency = 1
    nameL.Text               = name
    nameL.TextColor3         = THEME.TEXT_PRIMARY
    nameL.Font               = Enum.Font.GothamSemibold
    nameL.TextSize           = 9
    nameL.TextXAlignment     = Enum.TextXAlignment.Left
    nameL.Parent             = row

    local descL = Instance.new("TextLabel")
    descL.Size               = UDim2.new(1, -52, 0, 11)
    descL.Position           = UDim2.new(0, 8, 0, 22)
    descL.BackgroundTransparency = 1
    descL.Text               = desc or ""
    descL.TextColor3         = THEME.TEXT_MUTED
    descL.Font               = Enum.Font.Gotham
    descL.TextSize           = 7
    descL.TextXAlignment     = Enum.TextXAlignment.Left
    descL.Parent             = row

    local switch = Instance.new("Frame")
    switch.Size             = UDim2.new(0, 30, 0, 16)
    switch.Position         = UDim2.new(1, -40, 0.5, -8)
    switch.BackgroundColor3 = state and THEME.ACCENT or THEME.BG_HOVER
    switch.BorderSizePixel  = 0
    switch.Parent           = row
    corner(switch, 8)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.Position         = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    knob.Parent           = switch
    corner(knob, 6)

    local rowStroke = stroke(row, state and THEME.ACCENT_DIM or THEME.BORDER, 1, 0.5)

    local function doToggle()
        state = not state
        if state then
            tween(switch, 0.18, {BackgroundColor3 = THEME.ACCENT}):Play()
            tween(knob,   0.18, {Position = UDim2.new(1, -14, 0.5, -6)}):Play()
            tween(row,    0.18, {BackgroundColor3 = Color3.fromRGB(30, 22, 50)}):Play()
            rowStroke.Color = THEME.ACCENT_DIM
        else
            tween(switch, 0.18, {BackgroundColor3 = THEME.BG_HOVER}):Play()
            tween(knob,   0.18, {Position = UDim2.new(0, 2, 0.5, -6)}):Play()
            tween(row,    0.18, {BackgroundColor3 = THEME.BG_CARD}):Play()
            rowStroke.Color = THEME.BORDER
        end
        if callback then pcall(callback, state) end
    end

    -- Anti-drag: toggle hanya kalau tidak geser
    local dragThreshold = 6
    local startPos      = nil

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            startPos = input.Position
        end
    end)

    row.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if not startPos then return end
            local delta = (input.Position - startPos).Magnitude
            if delta < dragThreshold then doToggle() end
            startPos = nil
        end
    end)

    return {
        getState  = function() return state end,
        setState  = function(v) if v ~= state then doToggle() end end,
        descLabel = descL,
    }
end

-- ═══════════════════════════════════════════
-- BUTTON BUILDER
-- ═══════════════════════════════════════════
local function addFeatureButton(page, name, desc, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = THEME.BG_CARD
    row.BorderSizePixel  = 0
    row.Parent           = page
    corner(row, 8)
    stroke(row, THEME.BORDER, 1, 0.5)

    local nameL = Instance.new("TextLabel")
    nameL.Size               = UDim2.new(1, -70, 0, 14)
    nameL.Position           = UDim2.new(0, 8, 0, 7)
    nameL.BackgroundTransparency = 1
    nameL.Text               = name
    nameL.TextColor3         = THEME.TEXT_PRIMARY
    nameL.Font               = Enum.Font.GothamSemibold
    nameL.TextSize           = 9
    nameL.TextXAlignment     = Enum.TextXAlignment.Left
    nameL.Parent             = row

    local descL = Instance.new("TextLabel")
    descL.Size               = UDim2.new(1, -70, 0, 11)
    descL.Position           = UDim2.new(0, 8, 0, 22)
    descL.BackgroundTransparency = 1
    descL.Text               = desc or ""
    descL.TextColor3         = THEME.TEXT_MUTED
    descL.Font               = Enum.Font.Gotham
    descL.TextSize           = 7
    descL.TextXAlignment     = Enum.TextXAlignment.Left
    descL.Parent             = row

    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 54, 0, 22)
    btn.Position         = UDim2.new(1, -62, 0.5, -11)
    btn.BackgroundColor3 = THEME.BG_ACTIVE
    btn.Text             = "Run"
    btn.TextColor3       = THEME.ACCENT
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 8
    btn.BorderSizePixel  = 0
    btn.Parent           = row
    corner(btn, 6)
    stroke(btn, THEME.ACCENT_DIM, 1, 0.5)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.12, {BackgroundColor3 = THEME.ACCENT_DIM, TextColor3 = THEME.TEXT_PRIMARY}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.12, {BackgroundColor3 = THEME.BG_ACTIVE, TextColor3 = THEME.ACCENT}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.05, {BackgroundColor3 = THEME.ACCENT}):Play()
        task.delay(0.1, function() tween(btn, 0.15, {BackgroundColor3 = THEME.ACCENT_DIM}):Play() end)
        if callback then task.spawn(function() pcall(callback) end) end
    end)

    return { button = btn, descLabel = descL }
end

-- ═══════════════════════════════════════════
-- SECTION HEADER
-- ═══════════════════════════════════════════
local function createSection(page, title)
    local sec = Instance.new("TextLabel")
    sec.Size               = UDim2.new(1, 0, 0, 14)
    sec.BackgroundTransparency = 1
    sec.Text               = "  " .. title:upper()
    sec.TextColor3         = THEME.ACCENT
    sec.Font               = Enum.Font.GothamBold
    sec.TextSize           = 7
    sec.TextXAlignment     = Enum.TextXAlignment.Left
    sec.Parent             = page
end

-- ═══════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════
local UI = {
    THEME            = THEME,
    corner           = corner,
    stroke           = stroke,
    tween            = tween,
    makeDraggable    = makeDraggable,
    mainGui          = mainGui,
    mainFrame        = mainFrame,
    mainPage         = mainPage,
    combatPage       = combatPage,
    farmPage         = farmPage,
    miscPage         = miscPage,
    createToggle     = createToggle,
    addFeatureButton = addFeatureButton,
    createSection    = createSection,
    closeBtn         = closeBtn,
    openBtn          = openBtn,
    isOpen           = function() return isOpen end,
    closeUI          = closeUI,
    openUI           = openUI,
    onClose          = onClose,
}

return UI
