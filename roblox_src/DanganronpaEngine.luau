--!strict
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local AssetCatalog = require(script.Parent.AssetCatalog)
local Renderer = require(script.Parent.Renderer)

local Engine = {}

-- State
Engine.CurrentScript = nil :: any
Engine.CurrentStepIndex = 1
Engine.IsTyping = false
Engine.IsAuto = false
Engine.IsSkip = false
Engine.IsPaused = false
Engine.History = {} :: { { speaker: string, text: string } }

-- Event callbacks
Engine.OnTextUpdated = nil :: ((displayedText: string, isDone: boolean) -> ())?
Engine.OnSpeakerUpdated = nil :: ((name: string, color: Color3) -> ())?
Engine.OnBackgroundUpdated = nil :: ((bgKey: string) -> ())?
Engine.OnCharacterUpdated = nil :: ((charKey: string, spriteKey: string) -> ())?
Engine.OnScriptEnded = nil :: (() -> ())?

-- Parses authentic Danganronpa <CLT> tags to Roblox RichText
function Engine.FormatRichText(rawText: string): string
    local text = rawText
    -- Convert CLT 3 (Keywords / Ultimates) -> Neon Cyan bold
    text = string.gsub(text, "<CLT%s*3>", '<font color="#00ffcc"><b>')
    -- Convert CLT 4 (Inner Monologue / Narration) -> Soft Lavender/Blue italics
    text = string.gsub(text, "<CLT%s*4>", '<font color="#99bbff"><i>')
    -- Convert CLT 1 (Crimson / Danger) -> Hot Pink / Crimson
    text = string.gsub(text, "<CLT%s*1>", '<font color="#ff2a6d"><b>')
    -- Convert CLT closing tags
    text = string.gsub(text, "<CLT>", "</b></i></font>")
    return text
end

-- Strips tags to calculate true typing character length
function Engine.StripTags(richText: string): string
    return string.gsub(richText, "<[^>]->", "")
end

-- Play authentic SFX
function Engine.PlaySFX(sfxKey: string)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9114223170" -- Default UI feedback or custom sound
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

-- Load story script from JSON data or string
function Engine.LoadScriptData(scriptData: any)
    Engine.CurrentScript = scriptData
    Engine.CurrentStepIndex = 1
    Engine.History = {}
    print(string.format("[DanganronpaEngine] Loaded script '%s' with %d steps.", scriptData.name or "Script", scriptData.stepsCount or #scriptData.steps))
end

-- Execute current step
function Engine.ExecuteCurrentStep()
    if not Engine.CurrentScript or not Engine.CurrentScript.steps then return end
    local steps = Engine.CurrentScript.steps
    if Engine.CurrentStepIndex > #steps then
        if Engine.OnScriptEnded then Engine.OnScriptEnded() end
        return
    end

    local step = steps[Engine.CurrentStepIndex]
    local speakerName = step.speaker or "???"
    local charConfig = AssetCatalog.Characters[step.character]
    local speakerColor = charConfig and charConfig.Color or Color3.fromRGB(240, 240, 240)

    if step.isMonologue then
        speakerColor = Color3.fromRGB(160, 192, 255)
    end

    -- 1. Notify speaker
    if Engine.OnSpeakerUpdated then
        Engine.OnSpeakerUpdated(speakerName, speakerColor)
    end

    -- 2. Notify background
    if Engine.OnBackgroundUpdated and step.background then
        Engine.OnBackgroundUpdated(step.background)
    end

    -- 3. Notify character
    if Engine.OnCharacterUpdated and step.character then
        Engine.OnCharacterUpdated(step.character, step.sprite)
    end

    -- 4. Record history
    table.insert(Engine.History, {
        speaker = speakerName,
        text = step.text,
    })

    -- 5. Animate typewriter dialogue
    Engine.TypewriteText(step.text)
end

-- Typewriter text routine
function Engine.TypewriteText(rawText: string)
    Engine.IsTyping = true
    local formatted = Engine.FormatRichText(rawText)
    local plain = Engine.StripTags(formatted)
    local totalChars = #plain

    if Engine.IsSkip then
        -- Skip mode: immediate text
        Engine.IsTyping = false
        if Engine.OnTextUpdated then
            Engine.OnTextUpdated(formatted, true)
        end
        task.wait(0.08)
        Engine.Advance()
        return
    end

    task.spawn(function()
        local typeSpeed = 0.022 -- Authentic Danganronpa text speed
        local currentPlainLen = 0

        while currentPlainLen < totalChars and Engine.IsTyping do
            currentPlainLen += 1
            
            -- Substring plain text slice with tags
            -- To keep rich text valid while typing, display progressive plain text
            local slice = string.sub(plain, 1, currentPlainLen)
            if Engine.OnTextUpdated then
                Engine.OnTextUpdated(slice, false)
            end

            -- Click SFX every 3 characters
            if currentPlainLen % 3 == 0 then
                Engine.PlaySFX("TextClick")
            end

            task.wait(typeSpeed)
        end

        Engine.IsTyping = false
        if Engine.OnTextUpdated then
            Engine.OnTextUpdated(formatted, true)
        end

        -- Auto mode delay
        if Engine.IsAuto then
            task.wait(1.6)
            if Engine.IsAuto and not Engine.IsTyping then
                Engine.Advance()
            end
        end
    end)
end

-- Player requests to advance (Space, Click, Enter)
function Engine.Advance()
    if Engine.IsTyping then
        -- Finish current text immediately
        Engine.IsTyping = false
        return
    end

    Engine.CurrentStepIndex += 1
    Engine.ExecuteCurrentStep()
end

-- Toggle Auto-advance
function Engine.ToggleAuto(): boolean
    Engine.IsAuto = not Engine.IsAuto
    if Engine.IsAuto and not Engine.IsTyping then
        Engine.Advance()
    end
    return Engine.IsAuto
end

-- Toggle Skip
function Engine.ToggleSkip(): boolean
    Engine.IsSkip = not Engine.IsSkip
    if Engine.IsSkip then
        Engine.Advance()
    end
    return Engine.IsSkip
end

return Engine
