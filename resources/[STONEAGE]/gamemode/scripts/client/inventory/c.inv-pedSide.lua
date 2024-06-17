local PREVIEW = exports['stoneage_object_preview']

local pedSideSlots = 5

local preview = {ped, render}
function initPedSide()
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local x = sW * 0.5 - (w * 1.5) - pixels(10)
    local y = sH * 0.17

    local h = sH * 0.2 + (inv.size.y * (inv.boxSize + inv.margin)) + pixels(25)

    local bg = UI:CreateRectangle(x, y, w, h, false, inv.gui.bg, {
        bgColor = color('inv:boxColor'),
    })

    local lblNick = UI:createText(0, 0, w, pixels(30), '', false, bg, {
        font = cfont('franklin:medium'),
    })

    local lblLevel = UI:createText(0, pixels(30), w, pixels(20), '', false, bg, {
        font = cfont('franklin'),
    })

    local y = y + h - inv.boxSize - inv.margin * 2
    local slotsWidth = pedSideSlots * (inv.boxSize + inv.margin)
    local centerX = (x + w / 2) - slotsWidth / 2
    for i = 1, pedSideSlots do
        local x = centerX + (inv.boxSize + inv.margin) * (i - 1)
        createInvSlot('pedSide', x, y, inv.boxSize, inv.boxSize, i, bg)
    end

    guiSetVisible(bg, false)

    inv.gui.pedSide = {
        bg = bg,
        nick = lblNick,
        level = lblLevel,
    }

    inv.order.pedSide = getElementData(localPlayer, 'pedSideOrder') or {}
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if preview.render then
        PREVIEW:destroyObjectPreview(preview.render)
    end
end)

function showPedSide(state)
    local x, y = guiGetPosition(inv.gui.pedSide.bg, false)
    local w, h = guiGetSize(inv.gui.pedSide.bg, false)

    for k, v in ipairs(inv.gui.slots.pedSide) do
        guiSetVisible(v.bg, state)
    end

    guiSetVisible(inv.gui.pedSide.bg, state)

    if state then
        preview.ped = createPed(getElementModel(localPlayer), 0, 0, -30)
        setElementData(preview.ped, 'previewPed', true, false)
        for k, v in ipairs({0, 1, 2, 3, 16}) do
            setPedClothes(preview.ped, v, false)
        end

        preview.render = PREVIEW:createObjectPreview(preview.ped, 0, 0, 180, x, y + pixels(30) + pixels(20), w, h - pixels(60), false, true, true)
        PREVIEW:setDistanceSpread(preview.render, 0)

        guiSetText(inv.gui.pedSide.nick, getPlayerName(localPlayer))
        guiSetText(inv.gui.pedSide.level, ('LVL: %i'):format(getElementData(localPlayer, 'Level') or 0))

        for k, v in pairs(inv.order.pedSide) do
            applyClothes(preview.ped, v.itemName)
        end
    else
        if preview.ped and isElement(preview.ped) then
            destroyElement(preview.ped)
        end
    end
end

loadEvent('inv:updatePreviewCloth', localPlayer, function(clothName)
    if isElement(preview.ped) then
        applyClothes(preview.ped, clothName)
    end
end)

addEventHandler('onClientElementModelChange', localPlayer, function(_, modelID)
    if isElement(preview.ped) then
        setElementModel(preview.ped, modelID)
    end
end)

loadEvent('inv:removePreviewCloth', localPlayer, function(clothName)
    if isElement(preview.ped) then
        removeClothes(preview.ped, clothName)
    end
end)
