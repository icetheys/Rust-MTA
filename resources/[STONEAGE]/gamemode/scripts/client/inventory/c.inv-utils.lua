addEvent('onPlayerToggleInv', true)
addEvent('onPlayerEquipItem', true)

function createInvSlot(where, x, y, w, h, thisID, parent)

    if parent == false then
        parent = nil
    else
        parent = inv.gui.bg
    end

    local bg = UI:CreateRectangle(x, y, w, h, false, parent, {
        ['bgColor'] = color('inv:boxColor'),
    })

    if where == 'keybar' then
        local id = UI:createText(0, 0, 1, 1, thisID, true, bg, {
            ['font'] = cfont('franklin'),
            ['text-align-x'] = 'right',
            ['text-align-y'] = 'top',
        })
        guiSetAlpha(id, 0.2)
    end
    guiSetProperty(bg, 'AlwaysOnTop', 'True')

    local img = guiCreateStaticImage(0, 0, 1, 1, 'files/images/logo.png', true, bg)
    guiSetVisible(img, false)

    local quantity = UI:createText(0, 0, 1, 1, '', true, bg, {
        ['text-align-x'] = 'right',
        ['text-align-y'] = 'bottom',
        ['font'] = cfont('franklin'),
    })

    addEventHandler('onClientMouseEnter', quantity, function()
        if thisID > inv.maxSlots[where] then
            return
        end

        if not inv.selected or (inv.selected.source ~= where and inv.selected.id ~= thisID) then
            if where ~= 'keybar' or (inv.selectedKeyBarSlot ~= thisID) then
                UI:SetRectangleColor(bg, color('inv:boxColor:hover'))
            end
        end

        local w = guiGetSize(bg, false)
        local mainSize = inv.gui.slots[where][thisID].size
        if w == mainSize then
            local x, y = guiGetPosition(bg, false)
            guiSetPosition(bg, x + 1, y + 1, false)
            guiSetSize(bg, mainSize - 2, mainSize - 2, false)
        end

        inv.hover = {
            source = where,
            id = thisID,
            button = bg,
        }

        playSound('files/sounds/hover.mp3')
    end, false)

    addEventHandler('onClientMouseLeave', quantity, function()
        if thisID > inv.maxSlots[where] then
            return
        end

        if not inv.selected or (inv.selected.source ~= where and inv.selected.id ~= thisID) then
            if where ~= 'keybar' or (inv.selectedKeyBarSlot ~= thisID) then
                UI:SetRectangleColor(bg, color('inv:boxColor'))
            end
        end

        local mainSize = inv.gui.slots[where][thisID].size
        if inv.hover and inv.hover.id == thisID then
            local x, y = guiGetPosition(bg, false)
            guiSetPosition(bg, x - 1, y - 1, false)

            guiSetSize(bg, mainSize, mainSize, false)

            inv.hover = nil
        end
    end, false)

    inv.gui.slots[where][thisID] = {
        bg = bg,
        img = img,
        quantity = quantity,
        size = w,
        pos = {x, y},
    }

    guiSetVisible(bg, false)
    return bg
end

function onOrderChange(where, add, remove)
    local order = inv.order[where]
    local slots = inv.gui.slots[where]

    for k in pairs(add) do
        if slots[k] then
            if order[k] and order[k].quantity > 0 then
                guiStaticImageLoadImage(slots[k].img, getItemIcon(order[k].itemName))
                guiSetVisible(slots[k].img, true)

                guiSetText(slots[k].quantity, order[k].quantity)
            end
        end
    end

    for k in pairs(remove) do
        if order[k] then
            guiStaticImageLoadImage(slots[k].img, getItemIcon(order[k].itemName))
            guiSetVisible(slots[k].img, true)

            guiSetText(slots[k].quantity, order[k].quantity)
        else
            guiStaticImageLoadImage(slots[k].img, 'files/images/logo.png')
            guiSetVisible(slots[k].img, false)

            guiSetText(slots[k].quantity, '')

            UI:setImageColor(slots[k].bg, color('inv:boxColor'))
        end
    end
end

function orderDifference(t1, t2)
    local add = {}
    local remove = {}

    for k, v in pairs(t1) do
        if not t2[k] or t2[k].itemName ~= v.itemName or t2[k].quantity ~= v.quantity then --
            remove[k] = true
        end
    end

    for k, v in pairs(t2) do
        if not t1[k] or t1[k].itemName ~= v.itemName or t2[k].quantity ~= v.quantity then
            if not remove[k] then --
                add[k] = true
            end
        end
    end

    return add, remove
end

function updateBlockedSlots(where)
    local maxSlots = inv.maxSlots[where]

    for i = 1, (inv.size.x * inv.size.y) do

        local order = inv.order[where][i]
        local bg = inv.gui.slots[where][i].bg
        local img = inv.gui.slots[where][i].img
        local label = inv.gui.slots[where][i].quantity

        if i <= maxSlots then
            if order then
                guiStaticImageLoadImage(img, getItemIcon(order.itemName))
                guiSetVisible(img, true)
                guiSetText(label, order.quantity)
            else
                guiSetVisible(img, false)
                guiSetText(label, '')
            end
            guiSetAlpha(img, 1)
        else
            guiSetVisible(img, where == 'inv')
            guiSetText(label, '')
            guiSetAlpha(img, 0.1)

            if inv.hover then
                if inv.hover.source == where and inv.hover.id == i then
                    local x, y = guiGetPosition(bg, false)
                    guiSetPosition(bg, x - 1, y - 1, false)
                    guiSetSize(bg, inv.boxSize, inv.boxSize, false)
                    UI:setImageColor(bg, color('inv:boxColor'))
                    inv.hover = nil
                end
            end
            guiStaticImageLoadImage(img, 'files/images/ui/blockedsquare.png')
        end
    end
end

addEventHandler('onClientElementDataChange', localPlayer, function(key, old, new)
    if key == 'invOrder' then
        local add, remove = orderDifference(inv.order.inv or {}, new)

        inv.order.inv = new
        onOrderChange('inv', add, remove)
        inv.toggleDrag(false)

    elseif key == 'keybarOrder' then
        local add, remove = orderDifference(inv.order.keybar or {}, new)

        inv.order.keybar = new
        onOrderChange('keybar', add, remove)
        inv.toggleDrag(false)

    elseif key == 'pedSideOrder' then
        local add, remove = orderDifference(inv.order.pedSide or {}, new)

        inv.order.pedSide = new
        onOrderChange('pedSide', add, remove)
        inv.toggleDrag(false)

    elseif key == 'maxSlots' then
        inv.maxSlots.inv = new
        updateBlockedSlots('inv')

    end
end)

function onLootDataChange(key, old, new)
    if key == 'invOrder' then
        local add, remove = orderDifference(inv.order.loot or {}, new)
        inv.order.loot = new
        onOrderChange('loot', add, remove)
        inv.toggleDrag(false)
    end
end

function inv.toggleDrag(state, options)
    if state then
        inv.drag = {
            itemName = options.itemName,
            quantity = options.quantity,
            source = options.source,
            id = options.id,
        }
        blockInventoryID(options.source, options.id, 'drag')
        addEventHandler('onClientRender', root, syncDrag)
    else
        if inv.drag then
            if inv.drag.source and inv.drag.id then --
                receiveMoveSync(inv.drag.source, inv.drag.id, 'drag')
            end
        end
        removeEventHandler('onClientRender', root, syncDrag)
        inv.drag = nil
    end
end

function syncDrag()
    if isCursorShowing() then
        if inv.drag then
            local cx, cy = _getCursorPosition(true)
            local w = inv.boxSize
            local x, y = cx - w / 2, cy - w / 2
            dxDrawImage(x, y, w, w, getItemIcon(inv.drag.itemName), 0, 0, 0, tocolor(255, 255, 255, 255), true)
            dxDrawText(inv.drag.quantity, x, y, x + w, y + w, tocolor(210, 190, 175, 250), 1, font('franklin'), 'right', 'bottom', false, false, true)
        end
    end
end

function onPlayerClickOnItem()
    if inv.keepPressingTimer and isTimer(inv.keepPressingTimer) then
        killTimer(inv.keepPressingTimer)
    end

    if not inv.hover then
        return false
    end

    local hoverPos = inv.hover.id
    local hoverSource = inv.hover.source
    local order = hoverSource and inv.order[hoverSource]
    local hoverItem = hoverPos and order[hoverPos]

    if hoverItem then
        inv.toggleDrag(true, {
            itemName = hoverItem.itemName,
            quantity = hoverItem.quantity,
            source = hoverSource,
            id = hoverPos,
        })

        setSelectedItem(true, {
            itemName = hoverItem.itemName,
            quantity = hoverItem.quantity,
            source = hoverSource,
            id = hoverPos,
        })

    end
end

function getOptionsToUseItem(itemName, quantity)
    local options = {}
    local itemType = getItemType(itemName)
    if itemType == 'food' then
        options[1] = 'Comer'
    elseif itemType == 'drink' then
        options[1] = 'Beber'
    elseif itemType == 'blueprint' then
        options[1] = 'Aprender'
    end
    table.insert(options, 'Dropar')
    if itemName == 'Empty Bottle' and isElementInWater(localPlayer) then
        table.insert(options, 1, 'Encher Garrafa')
    end

    if quantity > 1 then
        table.insert(options, 2, 'Dividir')
    end
    return options
end

function getLoadingProcess(elem)
    return inv.loading[elem]
end

function startLoadingProcess(speed, elem, callback, ...)
    if getLoadingProcess(elem) then
        return false
    end
    inv.loading[elem] = 0

    local icon = guiCreateStaticImage(0, 0, 1, 1, 'files/images/ui/loading.png', true, elem)
    guiSetAlpha(icon, 0.3)

    setTimer(function(icon, ...)
        local _, rest = getTimerDetails(sourceTimer)
        inv.loading[elem] = 1.1 - (rest * 0.1)
        if isElement(icon) then
            if inv.loading[elem] == 1 then
                if inv.drag then
                    inv.toggleDrag(false)
                end
                if (not isNetworkLagDetected()) then
                    callback(...)
                end
                if isElement(icon) then -- sometimes callback will destroy it, then we need to re-check.
                    destroyElement(icon)
                end
                inv.loading[elem] = nil

            else
                guiStaticImageLoadImage(icon, ('files/images/ui/loading-%s.png'):format(inv.loading[elem] * 10))
            end
        else
            killTimer(sourceTimer)
            inv.loading[elem] = nil
        end
    end, speed, 10, icon, unpack({...}))

    return true
end

--[[REMOVE DO INVENTARIO QUANDO MANDA SOLICITACAO PRA DROPAR E DEVOLVE QD FINALIZAR A AÇÃO]]
waitingResponse = {}
function blockInventoryID(where, id, byMove, keepShowing)
    local arr = inv.gui.slots[where] and inv.gui.slots[where][id]
    if arr then
        if not keepShowing then
            guiSetVisible(arr.img, false)
            guiSetText(arr.quantity, '')
        end
        if (not byMove) then
            waitingResponse[id] = true
        end
    end
    if (where == 'inv') then
        local item = inv.order['inv'] and inv.order['inv'][id]
        if item then
            if (getItemType(item.itemName) == 'ammo') then
                inv.noAmmo = id
            end
        end
    end
end

function receiveMoveSync(where, id, byMove)
    if byMove and waitingResponse[id] then
        return
    end
    local arr = inv.gui.slots[where] and inv.gui.slots[where][id]
    if arr then
        local order = inv.order[where] and inv.order[where][id]
        if order and (order.quantity or 0) > 0 then
            guiSetVisible(arr.img, true)
            guiSetText(arr.quantity, order.quantity)
        end
    end
    if (id == inv.noAmmo) then
        inv.noAmmo = nil
    end
    waitingResponse[id] = nil
end
addEvent('receiveMoveSync', true)
addEventHandler('receiveMoveSync', localPlayer, receiveMoveSync)

addEventHandler('onClientKey', root, function(key)
    if (not inv.noAmmo) and (not isWaitingResponse()) then
        return false
    end

    if (not getBoundKeys('fire')[key]) then
        return false
    end

    toggleControl('fire', false)

    cancelEvent()
end)

isWaitingResponse = function()
    for k in pairs(waitingResponse) do
        return true
    end
    return false
end

function onPreFunction(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    local args = {...}
    if (args[1] == 'fire') and args[2] and inv.noAmmo then
        return 'skip'
    end
end
addDebugHook('preFunction', onPreFunction, {'toggleControl'})

function playItemSound(itemName)
    local possibleSounds = getItemPossibleSounds(itemName)
    if possibleSounds then
        local str = ('files/sounds/%s'):format(table.random(possibleSounds))
        local sound = playSound(str)
        setSoundVolume(sound, 0.2)
    end
end
addEvent('playItemSound', true)
addEventHandler('playItemSound', localPlayer, playItemSound)

addEvent('inv:onRemoveItemFromSlot', true)
addEventHandler('inv:onRemoveItemFromSlot', localPlayer, function(slot)
    if inv.drawing then
        if inv.selected and inv.selected.source == 'inv' and inv.selected.id == slot then
            setSelectedItem(false)
        end
    end
end)

function inv.allowToUseControls(state)
    local controls = {'fire', 'look_behind ', 'sprint', 'aim_weapon', 'jump', 'crouch'}
    for i = 1, #controls do
        toggleControl(controls[i], state)
    end
    if state and inv.noAmmo then
        toggleControl('fire', false)
    end
end

function playerUseItem(itemName, keybarSlot)
    local arr = keybarSlot and inv.gui.slots.keybar[keybarSlot]
    if arr then
        if inv.selectedKeyBarSlot == keybarSlot then
            disequipKeySlot(inv.selectedKeyBarSlot)
            return
        elseif inv.selectedKeyBarSlot then
            disequipKeySlot(inv.selectedKeyBarSlot)
        end

        if itemName == 'Planner' then
            if getElementData(localPlayer, 'editingObj') then
                return
            end
        end

        if getPedAnimation(localPlayer) then
            return false
        end

        triggerServerEvent('rust:onPlayerEquipItem', localPlayer, keybarSlot)
        UI:SetRectangleColor(arr.bg, color('inv:boxColor:selected'))
        inv.selectedKeyBarSlot = keybarSlot

        triggerEvent('onPlayerEquipItem', localPlayer, true, itemName, keybarSlot)
    end
end
loadEvent('playerUseItem', localPlayer, playerUseItem)

function playerConsumeItem(itemName, pos)
    if (getElementData(localPlayer, itemName) or 0) <= 0 then
        return
    end

    if getPedAnimation(localPlayer) then
        return false
    end

    blockInventoryID('inv', pos)
    triggerServerEvent('rust:onPlayerConsumeItem', localPlayer, itemName, pos)
    toggleInventory(false)
end

function disequipKeySlot(slotID)
    if not slotID or (not inv.gui.slots.keybar[slotID]) then
        return false
    end

    UI:SetRectangleColor(inv.gui.slots.keybar[slotID].bg, color('inv:boxColor'))

    triggerServerEvent('rust:onPlayerDisequipItem', localPlayer, slotID)

    local equippedItem = inv.order.keybar[slotID]
    local equippedItemName = equippedItem and equippedItem.itemName
    if equippedItemName then
        triggerEvent('onPlayerEquipItem', localPlayer, false, equippedItemName, inv.selectedKeyBarSlot)
        inv.selectedKeyBarSlot = nil
    end
end

addEvent('inv:disequipCurrentKeybarItem', true)
function disequipCurrentKeybarItem()
    disequipKeySlot(inv.selectedKeyBarSlot)
    -- inv.selectedKeyBarSlot = nil
end
addEventHandler('inv:disequipCurrentKeybarItem', localPlayer, disequipCurrentKeybarItem)
