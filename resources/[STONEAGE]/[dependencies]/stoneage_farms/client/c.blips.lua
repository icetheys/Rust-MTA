local Blips = {}

local config = {
    ['Tree'] = {35, 95, 35},
    ['Stone'] = {0, 165, 145},
    ['Iron'] = {230, 230, 230},
    ['Sulphur'] = {150, 150, 0},
}

local active = false

toggleNearBlips = function(state)
    if state then
        if active then
            return false
        end

        active = true

        for k, v in ipairs(getElementsByType('object', resourceRoot, true)) do
            if getElementData(v, 'obName') == 'farmObject' then
                local obType = getElementData(v, 'farmType')
                if config[obType] then
                    local r, g, b = unpack(config[obType])
                    local x, y, z = getElementPosition(v)
                    Blips[v] = createBlip(x, y, z, 0, 1, r, g, b)
                end
            end
        end

        addEventHandler('onClientElementStreamIn', resourceRoot, onStream)
        addEventHandler('onClientElementStreamOut', resourceRoot, onStream)
        addEventHandler('onClientElementDestroy', resourceRoot, onStream)
    else
        if not active then
            return
        end

        active = false

        for k, blip in pairs(Blips) do
            if isElement(blip) then
                destroyElement(blip)
            end
        end

        removeEventHandler('onClientElementStreamIn', resourceRoot, onStream)
        removeEventHandler('onClientElementStreamOut', resourceRoot, onStream)
        removeEventHandler('onClientElementDestroy', resourceRoot, onStream)
    end
end

onStream = function()
    if eventName == 'onClientElementStreamIn' then
        if getElementData(source, 'obName') == 'farmObject' then
            local obType = getElementData(source, 'farmType')
            if config[obType] then
                local r, g, b = unpack(config[obType])
                local x, y, z = getElementPosition(source)
                Blips[source] = createBlip(x, y, z, 0, 1, r, g, b)
            end
        end
    elseif (eventName == 'onClientElementStreamOut') or (eventName == 'onClientElementDestroy') then
        if Blips[source] then
            if isElement(Blips[source]) then
                destroyElement(Blips[source])
            end
            Blips[source] = nil
        end
    end
end

-- addEventHandler('onClientRender', root, function()
--     for k, v in ipairs(getElementsByType('object', resourceRoot, true)) do
--         local x, y, z = getElementPosition(v)
--         dxDrawLine3D(x,y,z, x,y,z+100)
--     end
-- end)
