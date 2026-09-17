local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })

QBCore.Functions.CreateCallback('qb-scoreboard:server:GetScoreboardData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local players = {}
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v then
            totalPlayers = totalPlayers + 1
            if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
                policeCount = policeCount + 1
            end
            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = QBCore.Functions.IsOptin(v.PlayerData.source)
        end
    end
    cb(totalPlayers, policeCount, players)
end)

-- Activity state is owned by trusted server resources, never config or clients.
AddEventHandler('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    if type(activity) ~= 'string' or not Config.IllegalActions[activity] or type(bool) ~= 'boolean' then return end
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)
