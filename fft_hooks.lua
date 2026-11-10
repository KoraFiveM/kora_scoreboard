-- Optional FFT development hooks (client). Listed last in fxmanifest.lua and
-- inert unless `setr fft_kora_hooks true`. No other file references FFT.
--
-- The scoreboard is a kora_lib AppShell app whose figures (player count, police
-- count, activity rows) live in file-local state in client/client.lua and reach
-- the UI only as a navigation tree. kora_lib's own FFT hook summarises app
-- payloads to a fixed depth that cuts off before the stat values and table
-- rows, so this hook records the navigation the scoreboard hands to
-- Kora.nui.updateApp and returns a flat, read-only summary of it. The wrapper
-- forwards every call unchanged; nothing here opens, closes or edits the app.
if GetConvar('fft_kora_hooks', 'false') ~= 'true' then return end

local RUNNER = 'fft'
local VERSION = 1
local APP_ID = 'qb-scoreboard:app' -- APP_ID in client/client.lua
local MAX_ROWS = 50

local function session()
    if GetResourceState(RUNNER) ~= 'started' then return nil end
    local id = LocalPlayer.state.fftSession
    return type(id) == 'string' and id or nil
end

local lastNavigation
local updates = 0

local forward = Kora.nui.updateApp
Kora.nui.updateApp = function(appId, update, ...)
    if appId == APP_ID and type(update) == 'table' and type(update.navigation) == 'table' then
        lastNavigation = update.navigation
        updates = updates + 1
    end
    return forward(appId, update, ...)
end

local function text(value)
    if value == nil then return nil end
    return tostring(value):sub(1, 80)
end

local function summarise(navigation)
    local view = { stats = {}, activities = {} }
    local content = type(navigation[1]) == 'table' and navigation[1].content
    for _, block in ipairs(type(content) == 'table' and type(content.blocks) == 'table' and content.blocks or {}) do
        if block.type == 'stats' then
            for _, item in ipairs(block.items or {}) do
                if #view.stats < MAX_ROWS then view.stats[#view.stats + 1] = { label = text(item.label), value = text(item.value) } end
            end
        elseif block.type == 'table' then
            for _, row in ipairs(block.rows or {}) do
                if #view.activities < MAX_ROWS then
                    local status = type(row.status) == 'table' and row.status.value or row.status
                    view.activities[#view.activities + 1] = {
                        label = text(row.activity),
                        required = tonumber(row.required),
                        status = text(status),
                    }
                end
            end
        end
    end
    return view
end

local actions = {}

-- Read-only summary of the figures last sent to the scoreboard app.
function actions.view()
    if not lastNavigation then return false, 'The scoreboard has not been opened since the hook loaded', 'not_open' end
    local view = summarise(lastNavigation)
    view.open = Kora.nui.isAppOpen(APP_ID) == true
    view.updates = updates
    return view
end

exports('fftVersion', function() return VERSION end)
exports('fftAction', function(action, ...)
    if GetInvokingResource() ~= RUNNER or not session() then
        return false, 'FFT hooks are disabled or session is not authorised'
    end
    local handler = actions[action]
    if not handler then return false, 'Unsupported FFT action: ' .. tostring(action) end
    return handler(...)
end)
