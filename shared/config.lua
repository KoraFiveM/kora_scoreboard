Config = Config or {}

Config.Toggle = true
Config.OpenKey = 'HOME'
Config.ShowIDforALL = false
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48)

Config.IllegalActions = {
    ['storerobbery'] = {
        minimumPolice = 1,
        label = 'Store Robbery',
    },
    ['bankrobbery'] = {
        minimumPolice = 3,
        label = 'Bank Robbery'
    },
    ['jewellery'] = {
        minimumPolice = 2,
        label = 'Jewelery'
    },
    ['pacific'] = {
        minimumPolice = 5,
        label = 'Pacific Bank'
    },
    ['paleto'] = {
        minimumPolice = 4,
        label = 'Paleto Bay Bank'
    }
}

Config.Toggle = QB.config.boolean(Config.Toggle, {
    label = 'Press to toggle scoreboard',
    description = 'When on, press the scoreboard key once to open and again to close. When off, keep the key held to view the scoreboard.',
})
Config.OpenKey = QB.config.string(Config.OpenKey, {
    label = 'Default scoreboard key', advanced = true,
    description = 'Default keyboard binding for new players, such as HOME or F10. Existing players keep their own binding in FiveM settings. Restart this resource after changing it.',
    minLength = 1, maxLength = 32,
})
Config.ShowIDforALL = QB.config.boolean(Config.ShowIDforALL, {
    label = 'Show nearby player IDs', live = true,
    description = 'Show an ID above every nearby player while the scoreboard is open. When off, only players who have opted in have their IDs shown.',
})
Config.MaxPlayers = QB.config.integer(Config.MaxPlayers, {
    label = 'Displayed player capacity', min = 1, max = 2048, live = true,
    description = 'Capacity displayed next to the online player count. This changes the display only; the actual connection limit is controlled by the server settings.',
})
for _, activity in pairs(Config.IllegalActions) do
    local label = activity.label
    activity.minimumPolice = QB.config.integer(activity.minimumPolice, {
        label = label .. ': police required', min = 0, max = 2048, live = true,
        description = 'Number of on-duty police needed for ' .. label .. ' to show as ready on the scoreboard. The robbery resource enforces its own rules; match its requirement here.',
    })
    activity.label = QB.config.string(label, {
        label = label .. ': display name', minLength = 1, maxLength = 80, live = true,
        description = 'Name shown for this activity on the scoreboard.',
    })
end
Config = QB.config.adopt(Config)
