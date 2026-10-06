local APP_ID = 'qb-scoreboard:app'

local playerOptin = {}
local nearbyPlayers = {}
local lastTotalPlayers = 0
local lastPoliceCount = 0
local opening = false
local keyHeld = false
local busyActivities = {}

local scanInterval = 500  -- ms between nearby-player distance scans
local renderInterval = 0  -- ms between draws while someone is nearby


local function drawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x, y, z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function scanNearbyPlayers(coords, distance, out)
    local count = 0
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            local targetCoords = GetEntityCoords(ped)
            if #(targetCoords - coords) <= distance then
                count = count + 1
                out[count] = player
            end
        end
    end
    for i = #out, count + 1, -1 do
        out[i] = nil
    end
    return count
end

local function startTracking()
    CreateThread(function()
        while QB.nui.isAppOpen(APP_ID) do
            scanNearbyPlayers(GetEntityCoords(PlayerPedId()), 10.0, nearbyPlayers)
            Wait(scanInterval)
        end
    end)

    CreateThread(function()
        while QB.nui.isAppOpen(APP_ID) do
            local wait = scanInterval
            for i = 1, #nearbyPlayers do
                local player = nearbyPlayers[i]
                local playerPed = GetPlayerPed(player)
                if DoesEntityExist(playerPed) then
                    local playerId = GetPlayerServerId(player)
                    local optin = playerOptin[playerId]
                    if Config.ShowIDforALL or (optin and optin.optin) then
                        local playerCoords = GetEntityCoords(playerPed)
                        wait = renderInterval
                        drawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, '[' .. playerId .. ']')
                    end
                end
            end
            Wait(wait)
        end
        nearbyPlayers = {}
    end)
end


local function policeStatus(id, activity)
    if busyActivities[id] then
        return { value = 'On cooldown', tone = 'warning', badge = true }
    end
    if lastPoliceCount >= activity.minimumPolice then
        return { value = 'Ready', tone = 'success', badge = true }
    end
    return { value = 'Needs more police', tone = 'destructive', badge = true }
end

local function buildActivityRows()
    local rows = {}
    for id, activity in pairs(Config.IllegalActions) do
        rows[#rows + 1] = {
            activity = activity.label,
            required = activity.minimumPolice,
            status = policeStatus(id, activity),
        }
    end
    table.sort(rows, function(a, b) return a.activity < b.activity end)
    return rows
end

local function buildNavigation()
    return { {
        id = 'overview',
        label = 'Overview',
        icon = 'Users',
        content = {
            title = 'Server status',
            blocks = {
                {
                    type = 'stats',
                    items = {
                        { label = 'Players online', value = ('%d / %d'):format(lastTotalPlayers, Config.MaxPlayers), icon = 'Users' },
                        { label = 'Police on duty', value = lastPoliceCount, icon = 'Shield' },
                    },
                },
                {
                    type = 'table',
                    title = 'Police-gated activities',
                    columns = {
                        { key = 'activity', label = 'Activity' },
                        { key = 'required', label = 'Required police', align = 'center' },
                        { key = 'status', label = 'Status', align = 'center' },
                    },
                    rows = buildActivityRows(),
                    empty = 'No police-gated activities are configured.',
                },
            },
        },
    } }
end

QB.nui.registerApp({
    id = APP_ID,
    title = 'Scoreboard',
    description = 'Server population and police-gated activity status.',
    icon = 'Users',
    layout = 'compact',
    width = 580,
    height = 620,
    placement = 'right',
    footer = Config.Toggle and ('Press %s or Escape to close'):format(Config.OpenKey)
        or ('Hold %s to view'):format(Config.OpenKey),
    navigation = buildNavigation(),
})


RegisterNetEvent('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    if not Config.IllegalActions[activity] then return end
    busyActivities[activity] = busy == true
    QB.nui.updateApp(APP_ID, { navigation = buildNavigation() })
end)


local function openScoreboard(fromKey)
    if opening or QB.nui.isAppOpen(APP_ID) then return end
    opening = true

    CreateThread(function()
        local totalPlayers, policeCount, playerList = QB.callback.trigger('qb-scoreboard:server:GetScoreboardData')
        if fromKey and not Config.Toggle and not keyHeld then opening = false return end
        playerOptin = playerList
        lastTotalPlayers = totalPlayers
        lastPoliceCount = policeCount
        QB.nui.updateApp(APP_ID, { navigation = buildNavigation() })

        local opened, err = pcall(QB.nui.openApp, APP_ID)
        opening = false
        if opened then startTracking() end
        if not opened then print(('[qb-scoreboard] could not open: %s'):format(tostring(err))) end
    end)
end

local function toggleScoreboard()
    if QB.nui.isAppOpen(APP_ID) then
        QB.nui.closeApp(APP_ID)
    else
        openScoreboard()
    end
end
RegisterCommand('scoreboard', toggleScoreboard, false)
RegisterCommand('+scoreboard', function()
    keyHeld = true
    if Config.Toggle then toggleScoreboard() else openScoreboard(true) end
end, false)
RegisterCommand('-scoreboard', function()
    keyHeld = false
    if not Config.Toggle then QB.nui.closeApp(APP_ID) end
end, false)
RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)

QB.config.bind('qbscoreboard', {}, function(values)
    Config = values
    if QB.nui.isAppOpen(APP_ID) then
        QB.nui.updateApp(APP_ID, { navigation = buildNavigation() })
    end
end)
