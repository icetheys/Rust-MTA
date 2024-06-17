UI = exports['stoneage_ui']
TRANSLATION = exports['stoneage_translations']
HIGHLIGHT = exports['stoneage_highlight']
UTILS = exports['stoneage_utils']

-- //------------------- EVENTS -------------------\\--
addEvent('rust:onClientPlayerLogin', true)
addEvent('rust:onClientPlayerDie', true)
addEvent('rust:onClientPlayerSpawn', true)
addEvent('rust:onClientPlayerEquipItem', true)
addEvent('rust:onClientPlayerDisequipItem', true)
-- //------------------- EVENTS -------------------\\--

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not getElementData(localPlayer, 'account') then
        -- toggleLogin(true)
        else
        fadeCamera(true, 1)
        if getElementData(localPlayer, 'isDead') then
            triggerEvent('rust:onClientPlayerDie', localPlayer, 'suicidio')
         end
    end

    for k, weaponModel in ipairs({343, 331, 333, 334, 335, 336, 337, 338, 339, 341, 346, 347, 348, 349, 350, 351, 352, 353, 372, 355, 356, 357, 358,
                                  359, 360, 361, 362, 342, 344, 365, 366, 367, 321, 322, 323, 325, 326, 368, 369, 371}) do
        engineSetModelLODDistance(weaponModel, 0.01)
    end

    setPlayerHudComponentVisible('all', false)
    setPlayerHudComponentVisible('crosshair', true)

    setWorldSoundEnabled(5, false)
    setAmbientSoundEnabled('gunfire', false)

    toggleControl('look_behind', false)
    toggleControl('next_weapon', false)
    toggleControl('previous_weapon', false)

    setTimer(decreasePlayerStats, 20000, 0)
    setTimer(drawBleedingEffects, 500, 0)
    setTimer(updateBleeding, 1500, 0)
    setTimer(checkBrokenbone, math.random(10000, 15000), 1)

    initHUD()
    setTimer(updateHUD, 500, 0)
    setTimer(updateAliveTime, 60000, 0)

    engineReplaceModel(engineLoadDFF('files/others/mng'), 362)
    engineReplaceModel(engineLoadDFF('files/others/mng'), 343)

    for k, v in ipairs(getElementsByType('player', root, true)) do
        setPlayerNametagShowing(v, false)
    end

    if getElementData(localPlayer, 'account') then
        toggleHUD(true)
    end

    toggleControl('radar', false)
    setPedAnimation(localPlayer)

    local Shader = dxCreateShader([[texture Tex0; technique simple{ pass P0{Texture[0] = Tex0;}}]])
    local Texture = dxCreateTexture(1, 1);
    engineApplyShaderToWorldTexture(Shader, "shad_ped")
    dxSetShaderValue(Shader, "Tex0", Texture)
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    fadeCamera(false, 1)
    -- setElementData(localPlayer, 'account', nil)
end)

-- //------------------- UPDATE PLAYER STATS -------------------\\--
function decreasePlayerStats()
    if getElementData(localPlayer, 'account') and not getElementData(localPlayer, 'isDead') and not isAdmin(localPlayer) then
        local blood = getElementData(localPlayer, 'blood')

        for k, valueName in ipairs({'fome', 'sede'}) do
            local have = getElementData(localPlayer, valueName) or 0
            if have > 0 then
                local decrease = getPlayerDataSetting(valueName, 'decreaseValue')()
                setElementData(localPlayer, valueName, math.max(have - decrease, 0))
            end

            if have <= 0 then
                local newBlood = blood - getPlayerDataSetting(valueName, 'bloodLoss')()
                setElementData(localPlayer, 'blood', newBlood)
                if newBlood <= 0 then
                    triggerServerEvent('player:onDie', localPlayer, {
                        reason = valueName,
                    })
                end
            elseif have >= 75 then
                local newBlood = math.min(getPlayerDataSetting('blood', 'max'), blood + 100)
                setElementData(localPlayer, 'blood', newBlood)
            end
        end
    end
end

function updateAliveTime()
    if not getElementData(localPlayer, 'isDead') and not getElementData(localPlayer, 'AFK') then
        setElementData(localPlayer, 'alivetime', (getElementData(localPlayer, 'alivetime') or 0) + 1)
        setElementData(localPlayer, 'alivetime:total', (getElementData(localPlayer, 'alivetime:total') or 0) + 1)

        local current_exp = getElementData(localPlayer, 'Exp')
        if (type(current_exp) == 'number') then
            setElementData(localPlayer, 'Exp', current_exp + math.random(1, 3))
        end
    end
end
-- //------------------- UPDATE PLAYER STATS -------------------\\--

-- //------------------- LIGHT THINGS -------------------\\--
local lights = {}

local lightableModels = {
    [2995] = true,
    [1773] = true,
    [1909] = true,
    [1264] = true,
    [1510] = true,
}

function changeLightableObjects()
    if getElementType(source) == 'object' then
        if lightableModels[getElementModel(source)] then
            if eventName == 'onClientElementStreamIn' then
                createLightToObject(source)
            else
                destroyLight(source)
            end
        end
        if getElementModel(source) == 1909 then
            setElementCollidableWith(localPlayer, source, false)
        end
    end
end
addEventHandler('onClientElementStreamIn', resourceRoot, changeLightableObjects)
addEventHandler('onClientElementStreamOut', resourceRoot, changeLightableObjects)
addEventHandler('onClientElementDestroy', resourceRoot, changeLightableObjects)

function createLightToObject(ob)
    if isElement(ob) and not lights[ob] then
        local model = getElementModel(ob)
        local fire = getElementData(ob, 'fire')

        local isTorch = model == 2995
        local isFornalha = model == 1773 and fire
        local isFogueira = model == 1909 and fire
        local isFixedTorch = model == 1510 and fire

        local x, y, z = getElementPosition(ob)

        if isTorch then
            lights[ob] = {createLight(0, x, y, z, 5, 255, 255, 50, 255), createEffect('Flame', x, y, z, 90, 90, 90, 400, true)}

        elseif isFogueira or isFixedTorch or isFornalha then
            lights[ob] = {createLight(0, x, y, z, 5, 255, 255, 50, 255), createEffect('fire', x, y, z, 90, 90, 90, 400, true)}

        end
        return true
    end
    return false
end

addEventHandler('onClientElementDataChange', resourceRoot, function(key, old, new)
    if getElementType(source) == 'object' and key == 'fire' then
        if new then
            createLightToObject(source)
        end
    end
end)

addEventHandler('onClientRender', root, function()
    for k, v in pairs(lights) do
        local x, y, z = getElementPosition(k)

        for k, elem in pairs(v) do
            if isElement(elem) then
                setElementPosition(elem, x, y, z)
            end
        end

        local model = getElementModel(k)
        if model == 1773 or model == 1909 or model == 1510 then
            if not getElementData(k, 'fire') then
                destroyLight(k)
            end
        end
    end
end)

function destroyLight(ob)
    if lights[ob] then
        for k, v in pairs(lights[ob]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        lights[ob] = nil
    end
end
-- //------------------- LIGHT THINGS -------------------\\--

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if (getElementType(source) == 'object') then
        setObjectBreakable(source, false)
    end
end)

function drawBleedingEffects()
    for k, player in ipairs(getElementsByType('player', root, true)) do
        local bleeding = getElementData(player, 'bleeding')
        if (bleeding or 0) > 0 then
            local px, py, pz = getPedBonePosition(player, math.random(1, 3))
            fxAddBlood(px, py, pz, 0, 0, 0, (bleeding / math.random(2, 3) * math.random(2)))
        end
        setPedFootBloodEnabled(player, (bleeding or 0) > 0)
    end
end

function updateBleeding()
    local bleeding = getElementData(localPlayer, 'bleeding') or 0
    if (bleeding > 0) then
        setElementData(localPlayer, 'blood', (getElementData(localPlayer, 'blood') or 0) - bleeding)
        setElementData(localPlayer, 'bleeding', math.floor(bleeding - (bleeding / 2)))
        if (getElementData(localPlayer, 'bleeding') or 0) <= 1 then
            setElementData(localPlayer, 'bleeding', 0)
        end

        if ((getElementData(localPlayer, 'blood') or 0) <= 0) and (not getElementData(localPlayer, 'isDead')) then
            triggerServerEvent('player:onDie', localPlayer, {
                reason = 'Bleeding',
            })
        end
    end
end

do
    local _, _, rz
    bindKey('lalt', 'both', function(key, state)
        if state == 'down' then
            _, _, rz = getElementRotation(localPlayer)
            addEventHandler('onClientPreRender', root, keepPedRotation)
        else
            removeEventHandler('onClientPreRender', root, keepPedRotation)
        end
    end)

    addEventHandler('onClientMinimize', root, function()
        removeEventHandler('onClientPreRender', root, keepPedRotation)
    end)

    function keepPedRotation()
        if not getKeyState('lalt') then
            removeEventHandler('onClientPreRender', root, keepPedRotation)
            return
        end
        setElementRotation(localPlayer, 0, 0, rz or 0, 'default', true)
    end
end

function checkBrokenbone()
    if getElementData(localPlayer, 'brokenbone') and not getPedAnimation(localPlayer) then
        triggerServerEvent('player:onFallByBrokenbone', localPlayer)
    end
    setTimer(checkBrokenbone, math.random(10000, 15000), 1)
end

-- //------------------- JOINQUIT -------------------\\--
-- addEventHandler('onClientPlayerJoin', root, function()
--     setTimer(function(player)
--         if (isElement(player)) then
--             outputChatBox(translate('entrou no jogo', nil, getPlayerName(player)), 255, 255, 255, true)
--         end
--     end, 2000, 1, source)
-- end)

-- addEventHandler('onClientPlayerQuit', root, function()
--     outputChatBox(translate('saiu do jogo', nil, getPlayerName(source)), 255, 255, 255, true)
-- end)
-- //------------------- JOINQUIT -------------------\\--

setTimer(function()
    for k, v in ipairs(getElementsNear(localPlayer, 'ped', 50)) do
        if getElementData(v, 'sleepingBody') then
            if getPedAnimation(v) == 'crack' then
                setPedAnimation(v, 'crack', 'crckidle2', -1, true, false, false, true, 0)
            else
                setPedAnimation(v, 'crack', 'crckidle2', -1, true, false, false, true, 500)
            end
        end
    end
    for k, v in ipairs(getElementsNear(localPlayer, 'player', 50)) do
        setPlayerNametagShowing(v, false)
    end
end, 2000, 0)

addEventHandler('onClientVehicleExplode', root, function()
    if source == getPedOccupiedVehicle(localPlayer) then
        triggerServerEvent('player:onDie', localPlayer, {
            reason = 'vehicle explosion',
        })
    end
end)
