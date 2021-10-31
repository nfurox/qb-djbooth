-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local currentZone = nil
local PlayerData = {}
local isLoggedin = false -- ADD THIS to the top of your client lua

AddEventHandler('onResourceStart', function(resource) --ADD above on playerloaded
   if resource == GetCurrentResourceName() then
      Wait(100)
      PlayerData = QBCore.Functions.GetPlayerData()
      isLoggedin = true

   end
end)

-- Handlers

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Static Header

local musicHeader = {
    {
        header = 'Play some music!',
        params = {
            event = 'qb-djbooth:client:playMusic'
        }
    }
}

-- Main Menu

local musicMenu = {
    {
        isHeader = true,
        header = '💿 | DJ Booth'
    },
    {
        header = '🎶 | Play a song',
        txt = 'Enter a youtube URL',
        params = {
            event = 'qb-djbooth:client:musicMenu',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '⏸️ | Pause Music',
        txt = 'Pause currently playing music',
        params = {
            event = 'qb-djbooth:client:pauseMusic',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '▶️ | Resume Music',
        txt = 'Resume playing paused music',
        params = {
            event = 'qb-djbooth:client:resumeMusic',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '🔈 | Change Volume',
        txt = 'Resume playing paused music',
        params = {
            event = 'qb-djbooth:client:changeVolume',
            args = {
                currentZone = currentZone
            }
        }
    },
    {
        header = '❌ | Turn off music',
        txt = 'Stop the music & choose a new song',
        isServer = true,
        params = {
            event = 'qb-djbooth:client:stopMusic',
            args = {
                currentZone = currentZone
            }
        }
    }
}

-- DJ Booths

local vanilla = BoxZone:Create(Config.Locations['vanilla'].coords, 1, 1, {
    name="vanilla",
    heading=0
})

vanilla:onPlayerInOut(function(isPointInside)
    Wait(200) -- ADD THIS
    if isLoggedin then  -- ADD THIS
        if isPointInside and Config.Locations['vanilla'].job == "all" or PlayerData.job.name == Config.Locations['vanilla'].job then -- ADD THIS
            currentZone = 'vanilla'
            exports['qb-menu']:showHeader(musicHeader)
        else
            currentZone = nil
            exports['qb-menu']:closeMenu()
        end
    end-- ADD THIS
end)

--[[vanilla:onPlayerInOut(function(isPointInside)
    Wait(200)
    if isLoggedin then 
        if isPointInside and Config.Locations['vanilla'].job == "all" or PlayerData.job.name == Config.Locations['vanilla'].job then
            currentZone = 'vanilla'
            exports['qb-menu']:showHeader(musicHeader)
        else
            currentZone = nil
            exports['qb-menu']:closeMenu()
        end
    end
end)]]--

local thelost = BoxZone:Create(Config.Locations['thelost'].coords, 1, 1, {
    name="thelost",
    heading=0
})

thelost:onPlayerInOut(function(isPointInside)
    Wait(200) -- ADD THIS
    if isLoggedin then  -- ADD THIS
        if isPointInside and Config.Locations['thelost'].job == "all" or PlayerData.job.name == Config.Locations['thelost'].job then -- ADD THIS
            currentZone = 'thelost'
            exports['qb-menu']:showHeader(musicHeader)
        else
            currentZone = nil
            exports['qb-menu']:closeMenu()
        end
    end-- ADD THIS
end)

-- Events

RegisterNetEvent('qb-djbooth:client:playMusic', function()
    exports['qb-menu']:openMenu(musicMenu)
end)

RegisterNetEvent("qb-djbooth:client:resumeMusic", function()
    TriggerServerEvent("qb-djbooth:server:resumeMusic",currentZone)
end)

RegisterNetEvent("qb-djbooth:client:pauseMusic", function()
    TriggerServerEvent("qb-djbooth:server:pauseMusic",currentZone)
end)
RegisterNetEvent("qb-djbooth:client:stopMusic", function()
    TriggerServerEvent("qb-djbooth:server:stopMusic",currentZone)
end)

RegisterNetEvent('qb-djbooth:client:musicMenu', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Song Selection',
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'song',
                text = 'YouTube URL'
            }
        }
    })
    if dialog then
        if not dialog.song then return end
        TriggerServerEvent('qb-djbooth:server:playMusic', dialog.song, currentZone)
    end
end)

RegisterNetEvent('qb-djbooth:client:changeVolume', function()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Music Volume',
        submitText = "Submit",
        inputs = {
            {
                type = 'number', -- 
                isRequired = true,
                name = 'volume',
                text = 'Min: 1[Off] - Max: 100[Max]'
            }
        }
    })
    if dialog then
        if not dialog.volume then return end
        TriggerServerEvent('qb-djbooth:server:changeVolume', dialog.volume, currentZone)
    end
end)
