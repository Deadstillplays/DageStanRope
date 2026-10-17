--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local AssetService = game:GetService("AssetService")
local HttpService = game:GetService("HttpService")

local AssetCatalog = require(script.Parent.AssetCatalog)
local Renderer = require(script.Parent.Renderer)
local Engine = require(script.Parent.DanganronpaEngine)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("=== Initializing Danganronpa: Trigger Happy Havoc in Roblox ===")

-- 1. Create Master ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanganronpaGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 10
screenGui.Parent = PlayerGui

-- 2. Viewport Container (16:9 Letterboxed Aspect Ratio)
local viewportFrame = Instance.new("Frame")
viewportFrame.Name = "ViewportFrame"
viewportFrame.Size = UDim2.new(1, 0, 1, 0)
viewportFrame.Position = UDim2.new(0, 0, 0, 0)
viewportFrame.BackgroundColor3 = Color3.fromRGB(8, 6, 12)
viewportFrame.BorderSizePixel = 0
viewportFrame.Parent = screenGui

local uiAspectRatio = Instance.new("UIAspectRatioConstraint")
uiAspectRatio.AspectRatio = 960 / 544
uiAspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
uiAspectRatio.DominantAxis = Enum.DominantAxis.Width
uiAspectRatio.Parent = viewportFrame

-- 3. EditableImage Canvas Viewport
local canvasLabel = Instance.new("ImageLabel")
canvasLabel.Name = "CanvasLabel"
canvasLabel.Size = UDim2.new(1, 0, 1, 0)
canvasLabel.Position = UDim2.new(0, 0, 0, 0)
canvasLabel.BackgroundTransparency = 1
canvasLabel.BorderSizePixel = 0
canvasLabel.ScaleType = Enum.ScaleType.Stretch
canvasLabel.Parent = viewportFrame

-- Create EditableImage
local okImage, editableImage = pcall(function()
    return AssetService:CreateEditableImage({ Size = Vector2.new(Renderer.CANVAS_WIDTH, Renderer.CANVAS_HEIGHT) })
end)

if okImage and editableImage then
    canvasLabel.ImageContent = Content.fromObject(editableImage)
    Renderer.Init(editableImage)
    Renderer.Clear(Color3.fromRGB(15, 12, 18))
    print("[DanganronpaClient] EditableImage initialized (960x544).")
else
    print("[DanganronpaClient] EditableImage not available in this context; fallback UI enabled.")
end

-- 4. Dialogue Box Container (Authentic Danganronpa Styling)
local dialogueContainer = Instance.new("Frame")
dialogueContainer.Name = "DialogueContainer"
dialogueContainer.Size = UDim2.new(0.92, 0, 0.28, 0)
dialogueContainer.Position = UDim2.new(0.04, 0, 0.68, 0)
dialogueContainer.BackgroundColor3 = Color3.fromRGB(18, 16, 24)
dialogueContainer.BackgroundTransparency = 0.15
dialogueContainer.BorderSizePixel = 0
dialogueContainer.Parent = viewportFrame

local diagCorner = Instance.new("UICorner")
diagCorner.CornerRadius = UDim.new(0, 8)
diagCorner.Parent = dialogueContainer

local diagStroke = Instance.new("UIStroke")
diagStroke.Color = Color3.fromRGB(255, 42, 109) -- Monokuma Neon Crimson/Pink
diagStroke.Thickness = 2.5
diagStroke.Transparency = 0.2
diagStroke.Parent = dialogueContainer

-- Accent Diagonal Corner Stripe
local accentStripe = Instance.new("Frame")
accentStripe.Name = "AccentStripe"
accentStripe.Size = UDim2.new(0.015, 0, 1, 0)
accentStripe.Position = UDim2.new(0, 0, 0, 0)
accentStripe.BackgroundColor3 = Color3.fromRGB(0, 255, 204) -- Neon Cyan
accentStripe.BorderSizePixel = 0
accentStripe.Parent = dialogueContainer

local stripeCorner = Instance.new("UICorner")
stripeCorner.CornerRadius = UDim.new(0, 4)
stripeCorner.Parent = accentStripe

-- 5. Speaker Badge (Angled Top-Left Nameplate)
local speakerBadge = Instance.new("Frame")
speakerBadge.Name = "SpeakerBadge"
speakerBadge.Size = UDim2.new(0.28, 0, 0.26, 0)
speakerBadge.Position = UDim2.new(0.02, 0, -0.32, 0)
speakerBadge.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
speakerBadge.BorderSizePixel = 0
speakerBadge.Parent = dialogueContainer

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 6)
badgeCorner.Parent = speakerBadge

local badgeStroke = Instance.new("UIStroke")
badgeStroke.Color = Color3.fromRGB(46, 204, 113) -- Dynamic per speaker
badgeStroke.Thickness = 2
badgeStroke.Parent = speakerBadge

local speakerLabel = Instance.new("TextLabel")
speakerLabel.Name = "SpeakerLabel"
speakerLabel.Size = UDim2.new(1, -16, 1, 0)
speakerLabel.Position = UDim2.new(0, 10, 0, 0)
speakerLabel.BackgroundTransparency = 1
speakerLabel.Font = Enum.Font.GothamBold
speakerLabel.Text = "Makoto Naegi"
speakerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speakerLabel.TextSize = 18
speakerLabel.TextXAlignment = Enum.TextXAlignment.Left
speakerLabel.Parent = speakerBadge

-- 6. Dialogue Text Label
local dialogueLabel = Instance.new("TextLabel")
dialogueLabel.Name = "DialogueLabel"
dialogueLabel.Size = UDim2.new(1, -44, 1, -24)
dialogueLabel.Position = UDim2.new(0, 24, 0, 14)
dialogueLabel.BackgroundTransparency = 1
dialogueLabel.Font = Enum.Font.GothamMedium
dialogueLabel.Text = "Hope's Peak Academy..."
dialogueLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
dialogueLabel.TextSize = 20
dialogueLabel.RichText = true
dialogueLabel.TextWrapped = true
dialogueLabel.TextXAlignment = Enum.TextXAlignment.Left
dialogueLabel.TextYAlignment = Enum.TextYAlignment.Top
dialogueLabel.Parent = dialogueContainer

-- 7. Blinking Advance Arrow Indicator
local nextArrow = Instance.new("TextLabel")
nextArrow.Name = "NextArrow"
nextArrow.Size = UDim2.new(0, 28, 0, 28)
nextArrow.Position = UDim2.new(1, -36, 1, -34)
nextArrow.BackgroundTransparency = 1
nextArrow.Font = Enum.Font.GothamBlack
nextArrow.Text = "▶"
nextArrow.TextColor3 = Color3.fromRGB(255, 42, 109)
nextArrow.TextSize = 20
nextArrow.Visible = false
nextArrow.Parent = dialogueContainer

task.spawn(function()
    while true do
        if nextArrow.Visible then
            nextArrow.TextTransparency = 0
            task.wait(0.35)
            nextArrow.TextTransparency = 1
            task.wait(0.35)
        else
            task.wait(0.2)
        end
    end
end)

-- 8. Control Pills Bar (Top-Right: Auto, Skip, Log, Reset)
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "ControlsFrame"
controlsFrame.Size = UDim2.new(0.32, 0, 0.06, 0)
controlsFrame.Position = UDim2.new(0.64, 0, 0.03, 0)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = viewportFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.Parent = controlsFrame

local function createPillButton(text: string, order: number, onClick: () -> ())
    local btn = Instance.new("TextButton")
    btn.Name = text .. "Button"
    btn.Size = UDim2.new(0, 72, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.Parent = controlsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 70, 95)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(onClick)
    return btn
end

local autoBtn = createPillButton("AUTO", 1, function()
    local isAuto = Engine.ToggleAuto()
    autoBtn.TextColor3 = isAuto and Color3.fromRGB(0, 255, 204) or Color3.fromRGB(220, 220, 220)
end)

local skipBtn = createPillButton("SKIP", 2, function()
    local isSkip = Engine.ToggleSkip()
    skipBtn.TextColor3 = isSkip and Color3.fromRGB(255, 42, 109) or Color3.fromRGB(220, 220, 220)
end)

createPillButton("LOG", 3, function()
    print("--- Dialogue History ---")
    for idx, h in ipairs(Engine.History) do
        print(string.format("[%d] %s: %s", idx, h.speaker, h.text))
    end
end)

-- 9. Connect Engine Callbacks
Engine.OnTextUpdated = function(displayText: string, isDone: boolean)
    dialogueLabel.Text = displayText
    nextArrow.Visible = isDone
end

Engine.OnSpeakerUpdated = function(name: string, color: Color3)
    speakerLabel.Text = name
    badgeStroke.Color = color
    speakerBadge.Visible = (name ~= "")
end

Engine.OnBackgroundUpdated = function(bgKey: string)
    print(string.format("[DanganronpaClient] Setting background: %s", bgKey))
end

Engine.OnCharacterUpdated = function(charKey: string, spriteKey: string)
    print(string.format("[DanganronpaClient] Setting character: %s (%s)", charKey, spriteKey))
end

-- 10. User Input Handlers
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Return or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Engine.Advance()
    elseif input.KeyCode == Enum.KeyCode.A then
        local isAuto = Engine.ToggleAuto()
        autoBtn.TextColor3 = isAuto and Color3.fromRGB(0, 255, 204) or Color3.fromRGB(220, 220, 220)
    elseif input.KeyCode == Enum.KeyCode.S then
        local isSkip = Engine.ToggleSkip()
        skipBtn.TextColor3 = isSkip and Color3.fromRGB(255, 42, 109) or Color3.fromRGB(220, 220, 220)
    end
end)

-- 11. Initial Script Loader (Load Prologue: Entrance Scene)
task.spawn(function()
    task.wait(0.5)

    -- Default embedded fallback prologue sequence
    local defaultStory = {
        name = "Prologue: Hope's Peak Academy",
        stepsCount = 10,
        steps = {
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>The massive high school towers over all the other buildings in this bustling urban area.<CLT>",
                background = "bgd_030",
                character = "makoto_naegi",
                sprite = "00",
            },
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>It's like the school stands at the center of the entire world.<CLT>",
                background = "bgd_030",
                character = "makoto_naegi",
                sprite = "00",
            },
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>Hope's Peak Academy... It brings in top students from every field imaginable.<CLT>",
                background = "bgd_030",
                character = "makoto_naegi",
                sprite = "00",
            },
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>They say that if you come here and manage to graduate, you'll be set for life.<CLT>",
                background = "bgd_030",
                character = "makoto_naegi",
                sprite = "00",
            },
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>It was built to raise <CLT 3>hope<CLT> in the nation's future. Which makes <CLT 3>Hope's Peak<CLT> a pretty fitting name.<CLT>",
                background = "bgd_030",
                character = "makoto_naegi",
                sprite = "00",
            },
            {
                speaker = "Makoto Naegi (Thought)",
                isMonologue = true,
                text = "<CLT 4>Standing before me were the <CLT 3>\"Ultimate Students\"<CLT> that I'd read about online...<CLT>",
                background = "bgd_010",
                character = "sayaka_maizono",
                sprite = "00",
            },
            {
                speaker = "Sayaka Maizono",
                isMonologue = false,
                text = "Um, excuse me... Are you Makoto Naegi from Sixth Black High?",
                background = "bgd_010",
                character = "sayaka_maizono",
                sprite = "05",
            },
            {
                speaker = "Makoto Naegi",
                isMonologue = false,
                text = "Y-Yeah, that's me! Sayaka Maizono... The <CLT 3>Ultimate Pop Sensation<CLT>!",
                background = "bgd_010",
                character = "makoto_naegi",
                sprite = "01",
            },
            {
                speaker = "Monokuma",
                isMonologue = false,
                text = "<CLT 1>Upupupu~! Is everyone gathered? Let the killing school life begin!<CLT>",
                background = "bgd_014",
                character = "monokuma",
                sprite = "01",
            },
        }
    }

    Engine.LoadScriptData(defaultStory)
    Engine.ExecuteCurrentStep()
end)

print("[DanganronpaClient] Client initialized and ready.")
