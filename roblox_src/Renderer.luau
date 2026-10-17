--!strict
local AssetService = game:GetService("AssetService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Renderer = {}
local Blend = Enum.ImageCombineType.BlendSourceOver
local Ovr = Enum.ImageCombineType.Overwrite

Renderer.CANVAS_WIDTH = 960
Renderer.CANVAS_HEIGHT = 544

Renderer.Canvas = nil :: EditableImage?
Renderer.ImageCache = {} :: { [string]: EditableImage }
Renderer.CurrentBackground = nil :: EditableImage?
Renderer.CurrentCharacter = nil :: EditableImage?
Renderer.CurrentCharPos = Vector2.new(160, 0) -- Center stage
Renderer.IsReady = false

-- Effects state
Renderer.FlashColor = Color3.new(1, 1, 1)
Renderer.FlashAlpha = 0
Renderer.ShakeOffset = Vector2.zero

function Renderer.Init(canvas: EditableImage)
    Renderer.Canvas = canvas
    Renderer.IsReady = true
end

-- Clear canvas with solid color
function Renderer.Clear(color: Color3)
    if not Renderer.Canvas then return end
    pcall(function()
        Renderer.Canvas:DrawRectangle(Vector2.zero, Vector2.new(Renderer.CANVAS_WIDTH, Renderer.CANVAS_HEIGHT), color, 0, Ovr)
    end)
end

-- Draw background to canvas
function Renderer.DrawBackground(bgImage: EditableImage?)
    local canvas = Renderer.Canvas
    if not canvas then return end
    Renderer.CurrentBackground = bgImage
    
    if bgImage then
        pcall(function()
            canvas:DrawImage(Renderer.ShakeOffset, bgImage, Ovr)
        end)
    else
        Renderer.Clear(Color3.fromRGB(15, 12, 18))
    end
end

-- Composite character sprite onto canvas with alpha blending
function Renderer.DrawCharacter(charImage: EditableImage?, xPos: number?, yPos: number?)
    local canvas = Renderer.Canvas
    if not canvas then return end
    Renderer.CurrentCharacter = charImage
    
    if charImage then
        local x = xPos or 160
        local y = yPos or 0
        local drawPos = Vector2.new(x + Renderer.ShakeOffset.X, y + Renderer.ShakeOffset.Y)
        pcall(function()
            canvas:DrawImage(drawPos, charImage, Blend)
        end)
    end
end

-- Redraws the composite scene (Background + Character + Screen Overlays)
function Renderer.RenderFrame()
    local canvas = Renderer.Canvas
    if not canvas then return end

    -- 1. Draw Background
    if Renderer.CurrentBackground then
        pcall(function()
            canvas:DrawImage(Renderer.ShakeOffset, Renderer.CurrentBackground, Ovr)
        end)
    else
        Renderer.Clear(Color3.fromRGB(20, 16, 24))
    end

    -- 2. Draw Active Character
    if Renderer.CurrentCharacter then
        local drawPos = Vector2.new(Renderer.CurrentCharPos.X + Renderer.ShakeOffset.X, Renderer.CurrentCharPos.Y + Renderer.ShakeOffset.Y)
        pcall(function()
            canvas:DrawImage(drawPos, Renderer.CurrentCharacter, Blend)
        end)
    end

    -- 3. Draw Flash Overlay if active
    if Renderer.FlashAlpha > 0.01 then
        pcall(function()
            canvas:DrawRectangle(
                Vector2.zero,
                Vector2.new(Renderer.CANVAS_WIDTH, Renderer.CANVAS_HEIGHT),
                Renderer.FlashColor,
                1 - Renderer.FlashAlpha,
                Blend
            )
        end)
    end
end

-- Trigger dramatic screen flash (e.g. Truth Bullet, Objection, Revelation)
function Renderer.Flash(color: Color3?, duration: number?)
    local c = color or Color3.new(1, 1, 1)
    local dur = duration or 0.35
    Renderer.FlashColor = c
    Renderer.FlashAlpha = 1

    task.spawn(function()
        local start = os.clock()
        while os.clock() - start < dur do
            local elapsed = (os.clock() - start) / dur
            Renderer.FlashAlpha = math.clamp(1 - elapsed, 0, 1)
            Renderer.RenderFrame()
            RunService.RenderStepped:Wait()
        end
        Renderer.FlashAlpha = 0
        Renderer.RenderFrame()
    end)
end

-- Trigger screen shake (e.g. shock, gavel slam, Monokuma appearance)
function Renderer.Shake(intensity: number?, duration: number?)
    local mag = intensity or 12
    local dur = duration or 0.4

    task.spawn(function()
        local start = os.clock()
        while os.clock() - start < dur do
            local elapsed = (os.clock() - start) / dur
            local currentMag = mag * (1 - elapsed)
            Renderer.ShakeOffset = Vector2.new(
                (math.random() - 0.5) * 2 * currentMag,
                (math.random() - 0.5) * 2 * currentMag
            )
            Renderer.RenderFrame()
            RunService.RenderStepped:Wait()
        end
        Renderer.ShakeOffset = Vector2.zero
        Renderer.RenderFrame()
    end)
end

-- Fast memory crop or buffer copy
function Renderer.CreateImageFromPixels(width: number, height: number, rgbaBuffer: buffer): EditableImage?
    local ok, img = pcall(function()
        local image = AssetService:CreateEditableImage({Size = Vector2.new(width, height)})
        image:WritePixelsBuffer(Vector2.zero, Vector2.new(width, height), rgbaBuffer)
        return image
    end)
    return ok and img or nil
end

return Renderer
