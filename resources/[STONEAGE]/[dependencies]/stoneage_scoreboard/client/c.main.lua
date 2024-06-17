sW, sH = guiGetScreenSize()

Scoreboard = {
    ServerName = '?',
    MaxPlayers = 0,
    Info = 'YOUR DISCORD INVITE',
    LastRefresh = 0,
    OpenTick = 0,
    DisplayList = {},
    Scroll = 0,
    Columns = {{
        Header = '#',
        Width = 0.1,
        GetValue = function(player, i)
            return i
        end,
    }, {
        Header = 'Name',
        Width = 0.25,
        GetValue = function(player)
            local playerName = getPlayerName(player)
            local colored = false

            local staffRole = getElementData(player, 'staffRole')
            if staffRole and (staffRole ~= 'Youtuber') then
                playerName = '#FF0000[' .. staffRole .. '] ' .. playerName
                colored = true
            elseif getElementData(player, 'VIP') then
                playerName = '#DAA520' .. playerName
                colored = true
            end
            return playerName, colored
        end,
    }, {
        Header = 'Level',
        Width = 0.075,
        GetValue = function(player)
            return getElementData(player, 'Level') or 0
        end,
    }, {
        Header = 'Kills',
        Width = 0.075,
        GetValue = function(player)
            return getElementData(player, 'murders') or 0
        end,
    }, {
        Header = 'K/D',
        Width = 0.1,
        GetValue = function(player)
            local total_kills = getElementData(player, 'murders:total') or 0
            local total_deaths = getElementData(player, 'deaths:total') or 0

            local kd
            if (total_kills == 0) or (total_deaths == 0) then
                kd = 0
            else
                kd = (total_kills / total_deaths)
            end

            local str = ('%i/%i (%0.2f)'):format(total_kills, total_deaths, kd)
            return str
        end,
    }, {
        Header = 'Alive Time',
        Width = 0.1,
        GetValue = function(player)
            local alivetime = getElementData(player, 'alivetime') or 0
            return ConvertMinutesToTime(alivetime) or '?'
        end,
    }, {
        Header = 'Group',
        Width = 0.2,
        GetValue = function(player)
            return getElementData(player, 'Group') or '*'
        end,
    }, {
        Header = 'Ping',
        Width = 0.1,
        GetValue = function(player)
            return getPlayerPing(player)
        end,
    }},
    OrderBy = 'Level',
}

local Init = function()
    ToggleScoreboard(true)

    triggerServerEvent('requestScoreboardServerInfo', localPlayer)

    setTimer(function()
        triggerServerEvent('requestScoreboardServerInfo', localPlayer)
    end, 20000, 0)

    bindKey('\'', 'both', ToggleScoreboard)
    bindKey('F5', 'both', ToggleScoreboard)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

ToggleScoreboard = function(key, state)
    if (state == 'down') then
        addEventHandler('onClientRender', root, Render)
        addEventHandler('onClientKey', root, OnKeyDown)
        OpenTick = getTickCount()
    else
        removeEventHandler('onClientRender', root, Render)
        removeEventHandler('onClientKey', root, OnKeyDown)
    end
end

ReceiveScoreboardServerInfo = function(serverName, maxPlayers)
    Scoreboard.ServerName = serverName
    Scoreboard.MaxPlayers = maxPlayers
end
addEvent('receiveScoreboardServerInfo', true)
addEventHandler('receiveScoreboardServerInfo', root, ReceiveScoreboardServerInfo)

getScoreBoardSize = function()
    local w = sW * 0.65
    local h = 40 + 20
    h = h + (#Scoreboard.DisplayList * 20)
    h = math.min(h, sH * 0.75)
    w, h = interpolateBetween(0, 0, 0, w, h, 0, (getTickCount() - OpenTick) / 500, 'OutBounce')
    return w, h
end

refreshScoreboard = function()
    local playerInfos = {}
    for k, v in ipairs(getElementsByType('player')) do
        if (not getElementData(v, 'anonimato')) and getElementData(v, 'account') then
            playerInfos[v] = {}
            for _, arr in ipairs(Scoreboard.Columns) do
                local value, colored = arr.GetValue(v)
                playerInfos[v][arr.Header] = {value, colored}
            end
        end
    end

    local list = {}
    for player, infos in pairs(playerInfos) do
        table.insert(list, {
            Player = player,
            Values = infos,
        })
    end

    table.sort(list, function(a, b)
        return (a.Values[Scoreboard.OrderBy][1] or 0) > (b.Values[Scoreboard.OrderBy][1] or 0)
    end)

    Scoreboard.DisplayList = list
end

getDisplayItems = function()
    if ((getTickCount() - Scoreboard.LastRefresh) >= 1000) then
        refreshScoreboard()
        Scoreboard.LastRefresh = getTickCount()
    end
    return Scoreboard.DisplayList
end

function ConvertMinutesToTime(value)
    if value then
        local hours = math.floor(value / 60)
        local minutes = math.floor(value - 60 * hours)
        return ('%02d:%02d'):format(hours, minutes)
    end
    return false
end

OnKeyDown = function(key, state)
    if (key == 'mouse_wheel_up') then
        Scoreboard.Scroll = math.max(0, Scoreboard.Scroll - 1)

    elseif (key == 'mouse_wheel_down') then
        if (not Scoreboard.RenderingLast) then
            Scoreboard.Scroll = Scoreboard.Scroll + 1
        end

    end
end
