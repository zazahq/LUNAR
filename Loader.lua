local HubName = "Lunar"
local DiscordLink = "https://discord.gg/hQZmkVpq8E"


local Games = {

    [1194478315] = { 
        name = "School of Chaos MMORPG", 
        url = "https://raw.githubusercontent.com/your-user/your-repo/main/soc_loader.lua" 
    }
}


local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Use GameId for the whole experience, fall back to PlaceId if GameId is 0
local CurrentId = game.GameId
if not CurrentId or CurrentId == 0 then
    CurrentId = game.PlaceId
end

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or HubName,
            Text = text,
            Duration = duration or 5,
        })
    end)
end

local function LoadScript(url)
    print(string.format("[%s] Downloading script from: %s", HubName, url))
    
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not scriptContent then
        Notify(HubName, "Error: Failed to download script.", 5)
        return warn("[Loader] HTTP Error: " .. tostring(scriptContent))
    end
    
    print(string.format("[%s] Script downloaded. Executing...", HubName))
    
    local loadSuccess, loadError = pcall(function()
        local func, compileError = loadstring(scriptContent)
        if not func then
            error("Compile Error: " .. tostring(compileError))
        end
        func()
    end)
    
    if loadSuccess then
        print(string.format("[%s] Script loaded successfully!", HubName))
        Notify(HubName, "Script loaded successfully.", 3)
    else
        warn("[Loader] Execution Error: " .. tostring(loadError))
        Notify(HubName, "Error executing the script.", 5)
    end
end


local gameData = Games[CurrentId]

if gameData then
    Notify(HubName, "Loading script for: " .. gameData.name .. "...", 3)
    task.wait(0.5)
    LoadScript(gameData.url)
else
    local msg = string.format("Game not supported. Game ID: %d", CurrentId)
    warn("[Loader] " .. msg .. " | Discord: " .. DiscordLink)
    Notify(HubName, "Game not supported!\nGame ID: " .. tostring(CurrentId) .. "\nJoin Discord for support.", 10)
end
