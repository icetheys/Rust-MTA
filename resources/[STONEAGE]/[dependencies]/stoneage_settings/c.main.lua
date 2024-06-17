GUI = {}

toggleConfigs = function(state)
    if isElement(GUI['Window']) then
        destroyElement(GUI['Window'])
    end

    if state then
        local w, h = pixels(650, 600)
        GUI['Window'] = UI:CreateRectangle((sW - w) / 2, (sH - h) / 2, w, h, false, nil, {
            bgColor = {210, 190, 175, 250},
        })

        GUI['Container'] = UI:CreateRectangle(1, 1, w - 2, h - 2, false, GUI['Window'])

        -- MIRAS
        do
            local x, y, w, h = pixels(20, 50, 300, 400)
            local label = UI:CreateLabel(x, y - 20, w, 20, translate('miras'), GUI['Container'], 'center', 'center')
            guiLabelSetColor(label, 210, 190, 175)

            local rec = UI:CreateRectangle(x, y, w, h, false, GUI['Container'])
            local bg = UI:CreateScrollPane(0, 0, w, h, false, rec, {})

            local column, row = 1, 1
            local myAim = getConfig('Crosshair', 4)

            local aims = {}
            for i = 1, 25 do
                local w, h = pixels(95, 95)
                local x, y = w * column, h * row

                local img = UI:createImage(x, y, w, h, ':stoneage_settings/icons/' .. i .. '.png', false, bg)
                local label = UI:createText(0, 0, 1, 1, i, true, img, {})
                guiLabelSetColor(label, 210, 190, 175)

                guiSetAlpha(label, i == myAim and 1 or 0.25)

                if column == 3 then
                    row = row + 1
                    column = 1
                else
                    column = column + 1
                end

                aims[i] = label

                addEventHandler('onClientGUIClick', label, function()
                    local myAim = getConfig('Crosshair', 4)
                    if myAim ~= i then
                        guiSetAlpha(aims[myAim], 0.25)
                        guiSetAlpha(label, 1)

                        setConfig('Crosshair', i)
                        createCrosshair()
                    end
                end, false)
            end
        end

        -- LINGUAGENS
        do
            local x, y, w, h = pixels(330), pixels(50), pixels(300), pixels(200)
            local label = UI:CreateLabel(x, y - 20, w, 20, translate('linguagens'), GUI['Container'], 'center', 'center')
            guiLabelSetColor(label, 210, 190, 175)
            GUI['LanguageList'] = UI:CreateList(x, y, w, h, false, GUI['Container'], {})

            local langs = {'pt', 'es', 'en', 'ar', 'ru', 'tr'}
            for k, v in ipairs(langs) do
                UI:addListItem(GUI['LanguageList'], v)
                if getElementData(localPlayer, 'Language') == v then
                    UI:setSelectedListItem(GUI['LanguageList'], k)
                end
            end

            addEventHandler('ui:onSelectListItem', GUI['LanguageList'], function(selectedText)
                setElementData(localPlayer, 'Language', selectedText)
                toggleConfigs(true)
            end)
        end

        -- BLIPS
        do
            local x, y, w = pixels(330, 260, 32)
            local checkbox = UI:CreateCheckbox(x, y, w, false, getConfig('FarmBlips', true), GUI['Container'], {})
            local label = UI:CreateLabel(x + w + pixels(10), y, 150, w, translate('blips'), GUI['Container'], 'left', 'center')
            guiLabelSetColor(label, 210, 190, 175)

            addEventHandler('onCheckBoxChangeState', checkbox, function(state)
                setConfig('FarmBlips', state)
                exports['stoneage_farms']:toggleNearBlips(state)
            end)
        end

        -- Compasso
        do
            local x, y, w = pixels(330, 300, 32)
            local checkbox = UI:CreateCheckbox(x, y, w, false, getConfig('Compasso', true), GUI['Container'], {})
            local label = UI:CreateLabel(x + w + pixels(10), y, 150, w, translate('Compasso'), GUI['Container'], 'left', 'center')
            guiLabelSetColor(label, 210, 190, 175)

            addEventHandler('onCheckBoxChangeState', checkbox, function(state)
                setConfig('Compasso', state)
                exports['stoneage_compass']:toggleCompass(state)
            end)
        end

        -- TEXTURAS
        do
            local x, y, w = pixels(330, 340, 32)
            local checkbox = UI:CreateCheckbox(x, y, w, false, getConfig('worldTextures', true), GUI['Container'], {})
            local label = UI:CreateLabel(x + w + pixels(10), y, 150, w, translate('worldTextures'), GUI['Container'], 'left', 'center')
            guiLabelSetColor(label, 210, 190, 175)

            addEventHandler('onCheckBoxChangeState', checkbox, function(state)
                setConfig('worldTextures', state)
                exports['stoneage_world_textures']:toggleWorldTextures(state)
            end)
        end

        -- FPS BOOST
        do
            local x, y, w = pixels(330, 380, 32)
            local checkbox = UI:CreateCheckbox(x, y, w, false, getConfig('FPSBoost', true), GUI['Container'], {})
            local label = UI:CreateLabel(x + w + pixels(10), y, 150, w, 'FPS++', GUI['Container'], 'left', 'center')
            guiLabelSetColor(label, 210, 190, 175)

            addEventHandler('onCheckBoxChangeState', checkbox, function(state)
                setConfig('FPSBoost', state)
                exports['stoneage_muros']:CheckForLODS(true)
                exports['gamemode']:CheckForLODS(true)
                if state then
                    setFarClipDistance(300)
                else
                    resetFarClipDistance()
                end
            end)
        end

        do
            local x, y, w, h = pixels(400, 500, 155, 50)
            local closeBtn = UI:CreateButton(x, y, w, h, translate('fechar'), false, GUI['Container'])
            addEventHandler('onClientGUIClick', closeBtn, function()
                toggleConfigs(false)
            end, false)
        end
    end
    showCursor(state)
end

getShader = function()
    return [[
        texture gTexture;
        technique simple
        {
            pass P0
            {
                Texture[0] = gTexture;
            }
        }
    ]]
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    local shader = dxCreateShader(getShader())
    local tex = dxCreateTexture('icons/sniper.png')
    engineApplyShaderToWorldTexture(shader, 'SNIPERcrosshair')
    dxSetShaderValue(shader, 'gTexture', tex)
    createCrosshair()
    
    -- toggleConfigs(true)

    if getConfig('FarmBlips', true) then
        exports['stoneage_farms']:toggleNearBlips(true)
    end
    if getConfig('worldTextures', true) then
        exports['stoneage_world_textures']:toggleWorldTextures(true)
    end
    if getConfig('Compasso', true) then
        exports['stoneage_compass']:toggleCompass(true)
    end
    if getConfig('FPSBoost', true) then
        setFarClipDistance(300)
    end
end)

local texture
local shader = dxCreateShader(getShader())

function createCrosshair()
    local myAim = getConfig('Crosshair', 4)
    local fileName = ('icons/%s.png'):format(myAim)
    if fileExists(fileName) then
        if isElement(texture) then
            destroyElement(texture)
        end
        texture = dxCreateTexture(fileName)
        engineApplyShaderToWorldTexture(shader, 'siteM16')
        dxSetShaderValue(shader, 'gTexture', texture)
    end
end

-- bindKey('f3', 'down', function()
--     if getElementData(localPlayer, 'account') and not getElementData(localPlayer, 'isDead') then
--         toggleConfigs(not isElement(GUI['Window']))
--     end
-- end)
