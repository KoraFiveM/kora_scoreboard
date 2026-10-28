local schema
local handlers, commands, registeredExports = {}, {}, {}
local opened, updates, pending, binding = false, 0, nil, nil
function GetCurrentResourceName() return 'kora_scoreboard' end
function IsDuplicityVersion() return true end
function GetConvarInt(_, fallback) return fallback end
function LoadResourceFile() return nil end
function AddEventHandler(name, handler) handlers[name] = handler end
function RegisterNetEvent(name, handler) handlers[name] = handler end
function RegisterCommand(name, handler) commands[name] = handler end
function RegisterKeyMapping(name) assert(name == '+scoreboard') end
function CreateThread(handler) pending = handler end
exports = setmetatable({ kora_core = { createCallback = function() end } }, {
    __call = function(_, name, handler) registeredExports[name] = handler end,
})
local makeConfig = dofile('../kora_lib/modules/config/consumer.lua')
QB = { callback = { trigger = function(name)
    assert(name == 'qb-scoreboard:server:GetScoreboardData')
    return 1, 0, {}
end }, config = makeConfig({ config_register = function(_, definition) schema = definition.schema end }), nui = {
    registerApp = function() end,
    isAppOpen = function() return opened end,
    openApp = function() opened = true end,
    closeApp = function() opened = false end,
    updateApp = function() updates = updates + 1 end,
} }
dofile('shared/config.lua')
assert(schema.fields.OpenKey.advanced, 'default key must be advanced')
assert(schema.fields.ShowIDforALL.live, 'ID visibility must update live')
assert(not schema.fields.IllegalActions.fields.storerobbery.fields.busy, 'runtime activity state must not be editable config')
QB.config.bind = function(resource, path, callback)
    assert(resource == 'kora_scoreboard' and #path == 0)
    binding = callback
end
dofile('client/client.lua')
Config.Toggle = false
commands['+scoreboard']()
commands['-scoreboard']()
pending(1, 0, {})
assert(not opened, 'releasing while the callback is pending must cancel opening')
commands['+scoreboard']()
pending(1, 0, {})
assert(opened, 'holding the key opens the scoreboard')
commands['-scoreboard']()
assert(not opened, 'releasing closes the scoreboard')
Config.Toggle = true
commands['+scoreboard']()
pending(1, 0, {})
commands['-scoreboard']()
assert(opened, 'toggle mode stays open after release')
local previous = updates
binding(Config)
assert(updates == previous + 1, 'live settings refresh an open scoreboard')
handlers['qb-scoreboard:client:SetActivityBusy']('storerobbery', true)
assert(Config.IllegalActions.storerobbery.busy == nil, 'runtime busy state stays outside configuration')
commands['+scoreboard']()
assert(not opened, 'second press closes toggle mode')
RegisterNetEvent = function() error('activity changes must not be client-callable') end
local broadcasts = 0
function TriggerClientEvent() broadcasts = broadcasts + 1 end
dofile('server/server.lua')
handlers['qb-scoreboard:server:SetActivityBusy']('missing', true)
handlers['qb-scoreboard:server:SetActivityBusy']('storerobbery', 'yes')
assert(broadcasts == 0, 'invalid activity updates must be rejected')
handlers['qb-scoreboard:server:SetActivityBusy']('storerobbery', true)
assert(broadcasts == 1, 'trusted valid activity updates are published')
print('scoreboard: configuration, hold/toggle, live refresh and trusted activity checks passed')
