function initKeyBar()
    local x = sW * 0.5 - (inv.size.x * (inv.boxSize + inv.margin) / 2)
    local y = sH * 0.4 + (inv.size.y * (inv.boxSize + inv.margin)) + inv.boxSize / 2
    
    for i = 1, inv.size.x do
        local x = x + (i - 1) * (inv.boxSize + inv.margin)
        createInvSlot('keybar', x, y, inv.boxSize, inv.boxSize, i, false)
    end
    inv.order.keybar = getElementData(localPlayer, 'keybarOrder') or {}
end

function toggleKeyBar(state, onTop)
    for k, v in ipairs(inv.gui.slots.keybar) do
        local originalX = guiGetPosition(v.bg, false)

        local y 
        if onTop then
            y = sH * 0.4 + (inv.size.y * (inv.boxSize + inv.margin)) + inv.boxSize / 2
        else
            y = sH - inv.boxSize - inv.margin
        end

        inv.gui.slots['keybar'][k].pos[2] = y

        guiSetPosition(v.bg, originalX, y, false)
        guiSetVisible(v.bg, state)
        guiBringToFront(v.bg)
    end
end

addCommandHandler('keybar', function()
	toggleKeyBar(false)
end)

function toggleKeyBarOnDieOrSpawn()
    toggleKeyBar(eventName == 'rust:onClientPlayerSpawn')
end
addEventHandler('rust:onClientPlayerDie', localPlayer, toggleKeyBarOnDieOrSpawn)
addEventHandler('rust:onClientPlayerSpawn', localPlayer, toggleKeyBarOnDieOrSpawn)

--// TEMP
-- addEventHandler('onClientResourceStart', resourceRoot, function()
--     setTimer(function()
--         toggleKeyBarOnDieOrSpawn()
--     end, 50, 1)
-- end)

local lastKeyDown = 0
local lastShot = 0

keybarToggleItem = function(key)
    if getElementData(localPlayer, 'desmaiado') then
        return false
    end

    if getPedControlState(localPlayer, 'aim_weapon') then
        return false
    end

    if getPedControlState(localPlayer, 'fire') then
        return false
    end

    local id = tonumber(key)

    local order = inv.order.keybar and inv.order.keybar[id]

    if order then
        playerUseItem(order.itemName, id)
    end

    return true
end

local timerCall

for i = 1, inv.size.x do
    bindKey(i, 'down', function(key)
        if ((getTickCount() - lastShot) <= 1000) or ((getTickCount() - lastKeyDown) <= 500) then
            if (not isTimer(timerCall)) then
                timerCall = setTimer(keybarToggleItem, 300, 1, key)
            else
                resetTimer(timerCall)
            end
            return false
        end
        
        lastKeyDown = getTickCount()
        keybarToggleItem(key)
    end)
end

bindKey('fire', 'down', function()
    local weapons = {
        [0] = true,
        [1] = true,
    }

    if weapons[getPedWeaponSlot(localPlayer)] then
        return false
    end

    lastShot = getTickCount()
end)

addEventHandler('onClientKey', root, function(key, state)
    local fireButtons = getBoundKeys('fire')

    if (not fireButtons[key]) then 
        return 
    end

    if (getPedWeaponSlot(localPlayer) <= 1) then 
        return 
    end

    if getPedControlState(localPlayer, 'aim_weapon') then 
        return 
    end

    cancelEvent()
end)

addEventHandler('onClientPlayerWeaponFire', localPlayer, function()
    if getPedControlState(localPlayer, 'aim_weapon') then 
        return 
    end

    setPedControlState(localPlayer, 'fire', false)
end)