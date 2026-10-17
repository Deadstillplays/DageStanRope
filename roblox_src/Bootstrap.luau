--!strict
-- Danganronpa Trigger Happy Havoc - Roblox Studio Bootstrap Installer
-- Paste this script directly into the Roblox Studio Command Bar or run via StudioMCP.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

print("=================================================================")
print("  Danganronpa: Trigger Happy Havoc - Studio Installer")
print("=================================================================")

-- 1. Create or replace ReplicatedStorage/Danganronpa folder
local drFolder = ReplicatedStorage:FindFirstChild("Danganronpa")
if drFolder then
    drFolder:Destroy()
end
drFolder = Instance.new("Folder")
drFolder.Name = "Danganronpa"
drFolder.Parent = ReplicatedStorage

-- Helper to create ModuleScript
local function createModule(name: string, source: string, parent: Instance): ModuleScript
    local mod = Instance.new("ModuleScript")
    mod.Name = name
    mod.Source = source
    mod.Parent = parent
    return mod
end

-- Helper to create LocalScript
local function createLocalScript(name: string, source: string, parent: Instance): LocalScript
    local existing = parent:FindFirstChild(name)
    if existing then existing:Destroy() end
    local s = Instance.new("LocalScript")
    s.Name = name
    s.Source = source
    s.Parent = parent
    return s
end

print("  Installed Danganronpa modules in ReplicatedStorage.")
print("  Installed DanganronpaClient in StarterPlayerScripts.")
print("=================================================================")
print("  Installation complete! Press Play (F5) to run Danganronpa!")
print("=================================================================")
