addEvent('onClientPlayerFaint', true)
addEvent('onClientPlayerGetsSaved', true)

Fonts = {
    Main = dxCreateFont('assets/futura.ttf', pixels(15)),
}

Faint = {
    initTick = nil,
    saving = nil,
}

TEMPO_ATE_MORRER = 25000
TEMPO_ATE_SER_SALVO = 5000

toggleFaint = function(state)
    if state then
        Faint.initTick = getTickCount()
        addEventHandler('onClientRender', root, Draw)
        Faint.timer = setTimer(function()
            triggerServerEvent('player:onDie', localPlayer, {
                reason = 'faint',
            })
        end, TEMPO_ATE_MORRER, 1)

        Faint.sound = playSound('assets/breath.ogg', true)
        setSoundVolume(Faint.sound, 0.7)

    else

        if isTimer(Faint.timer) then
            killTimer(Faint.timer)
        end

        if isElement(Faint.sound) then
            destroyElement(Faint.sound)
        end

        Faint.saving = nil
        Faint.initTick = nil
        Faint.timer = nil
        Faint.sound = nil
        removeEventHandler('onClientRender', root, Draw)
    end
    exports['gamemode']:toggleHUD(not state)
    exports['gamemode']:toggleKeyBar(not state)
end
addEventHandler('onClientPlayerFaint', localPlayer, toggleFaint)

toggleSaving = function(state, responsiblePlayer)
    if state then
        if Faint.beingSaved then
            return
        end
        Faint.beingSaved = {
            player = responsiblePlayer,
            timer = setTimer(function()
                triggerServerEvent('onPlayerFaint', localPlayer, false)
            end, TEMPO_ATE_SER_SALVO, 1),
        }
    else
        if not Faint.beingSaved then
            return
        end

        if isTimer(Faint.beingSaved.timer) then
            killTimer(Faint.beingSaved.timer)
        end

        Faint.beingSaved = nil
    end
end
addEventHandler('onClientPlayerGetsSaved', localPlayer, toggleSaving)

Draw = function()
    local percent = math.min(1, (getTickCount() - Faint.initTick) / TEMPO_ATE_MORRER)

    local pulse = math.abs((getTickCount() % 10) / 2000)

    dxDrawRectangle(0, 0, sW, sH, tocolor(30, 30, 30, 230))

    local w, h = pixels(550, 150)
    local x, y = (sW - w) / 2, (sH - h) / 2
    local margin = 3

    dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30, 250))

    local r, g, b = interpolateBetween(105, 126, 60, 255, 0, 0, percent, 'Linear')
    dxDrawRectangle(x + margin, y + margin, interpolateBetween(0, 0, 0, w - margin * 2, 0, 0, percent, 'Linear'), h - margin * 2,
        tocolor(r, g, b, 200))

    local str
    if Faint.beingSaved then
        if isElement(Faint.beingSaved.player) then
            str = exports['stoneage_translations']:translate('inconsciente 2', nil, getPlayerName(Faint.beingSaved.player), percent * 100)
        else
            toggleSaving(false)
        end
    else
        str = exports['stoneage_translations']:translate('inconsciente 1', nil, percent * 100)
    end
    dxDrawText(str, x, y, x + w, y + h, tocolor(255, 255, 255, 255), 1 + pulse, Fonts.Main, 'center', 'center')
end

-- addEventHandler('onClientResourceStart', resourceRoot, function()
--     fadeCamera(true)
--     setPedAnimation(localPlayer)

--     triggerServerEvent('onPlayerFaint', localPlayer, true)
-- end)

setTimer(function()
    for k, v in ipairs(getElementsByType('player', root, true)) do
        if not getPedAnimation(v) and getElementData(v, 'desmaiado') then
            setPedAnimation(v, 'SWEET', 'Sweet_injuredloop', -1, true, false, false, false)
        end
    end
end, 1000, 0)
