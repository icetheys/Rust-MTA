UI = exports['stoneage_ui']

Ranking = {
    List = {},
}

local GUI = {
    ['Buttons'] = {},
}
local sW, sH = guiGetScreenSize()

local w, h = 300, 400
local selectedListID = false

local Init = function()
    GUI['Background'] = UI:CreateWindow((sW - w) / 2, (sH - h) / 2, w, h, 'Ranking', false, false, true, {
        bgColor = {20, 20, 20, 255},
    })

    addEventHandler('onCustomWindowClose', GUI['Background'], function()
        toggleRanking(false)
    end)

    for k, v in ipairs({'alivetime:total', 'murders:total', 'Level'}) do
        GUI['Buttons'][k] = UI:CreateButton(10, math.floor((40 + 3) * k), w - 20, 40, exports['stoneage_translations']:translate(v), false, GUI['Background'], {})
        addEventHandler('onClientGUIClick', GUI['Buttons'][k], function()
            setSelectedList(k, v)
        end)
    end

    guiSetVisible(GUI['Background'], false)
    triggerServerEvent('requestRankingList', localPlayer)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

setSelectedList = function(listID, type)
    if selectedListID then
        if isElement(GUI['ListBG']) then
            destroyElement(GUI['ListBG'])
        end
    end

    if selectedListID ~= listID then
        selectedListID = listID
    else
        selectedListID = nil
    end

    local x, y = 10, 0
    for k, v in ipairs(GUI['Buttons']) do
        y = y + (40 + 3)
        guiSetPosition(getElementParent(v), x, y, false)
        if selectedListID and (k == listID) then
            GUI['ListBG'] = UI:CreateRectangle(10, y + 43, w - 20, 200, false, GUI['Background'], {})
            GUI['List'] = UI:CreateScrollPane(0, 0, w - 20, 200, false, GUI['ListBG'], {})
            for k, v in ipairs(Ranking.List[type]) do
                UI:CreateButton(0, (30 + 3) * (k - 1), 300 - 20, 30, ('#%s %s (x%s)'):format(k, v.lastNick, v[type]), false, GUI['List'], {})
            end
            y = y + 200 + 3
        end
    end
end

addEvent('receiveRankingList', true)
addEventHandler('receiveRankingList', localPlayer, function(list)
    Ranking.List = list
end)

toggleRanking = function(state)
    if state then
        for k, v in ipairs({'alivetime:total', 'murders:total', 'Level'}) do
            guiSetText(GUI['Buttons'][k], exports['stoneage_translations']:translate(v))
        end
    end
    guiSetVisible(GUI['Background'], state)
    showCursor(state)
end
