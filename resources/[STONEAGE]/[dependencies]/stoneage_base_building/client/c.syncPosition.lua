setElementData(localPlayer, 'editingObj', false)

local cacheCanCraft = {false, 'loading'}

local last = 0
function Craft.SyncObjectPosition()
    if getTickCount() - last < 15 then
        return
    end

    last = getTickCount()

    if Craft.Object then
        local can, reason = cacheCanCraft[1], cacheCanCraft[2]

        local x1, y1, z1 = getWorldFromScreenPosition(sW / 2, sH / 2, 0)
        local x2, y2, z2 = getWorldFromScreenPosition(sW / 2, sH / 2, 10)

        local hit, x, y, z, element = processLineOfSight(x1, y1, z1, x2, y2, z2, true, -- checkBuildings 
        false, -- checkVehicles 
        false, -- checkPlayers 
        true, -- checkObjects 
        false, -- checkDummies 
        false, -- seeThroughStuff 
        false, -- ignoreSomeObjectsForCamera 
        false, -- shootThroughStuff 
        localPlayer, -- ignoredElement 
        false, -- includeWorldModelInformation 
        false -- bIncludeCarTyres 
        )

        Craft.CanSave = false
        local cameraX, cameraY = getCameraMatrix()

        if hit then
            local rx, ry, rz = 0, 0, (-atan2(cameraX - x, cameraY - y) / pi * 180) + (Craft.FrontToPlayer and 180 or 0) + Craft.Offset.rz
            
            if element then
                local offX, offY, offZ, offRX, offRY, offRZ = canAttachObjects(Craft.Object, element, Craft.ObjectType)
                if offX then
                    x, y, z, rx, ry, rz = offX, offY, offZ, offRX, offRY, offRZ

                    highlightObject2(Craft.Object, 255, 255, 0, 200)
                    Craft.CanSave = true
                else
                    local posX, posY, posZ = getWorldOffsets(Craft.ObjectType)
                    x = x + posX
                    y = y + posY
                    z = z + posZ + Craft.Offset.z
                end
            else
                local posX, posY, posZ = getWorldOffsets(Craft.ObjectType)
                x = x + posX
                y = y + posY
                z = z + posZ + Craft.Offset.z
            end

            if Craft.ObjectType == 'Fundação' or Craft.ObjectType == 'Fundação Triangular' or Craft.ObjectType == 'Meia Fundação' then
                if not isNearToGround(x, y, z) then
                    can, reason = false, Craft.FlyingString
                    highlightObject2(Craft.Object, 255, 0, 0, 200)
                    Craft.CanSave = false
                else
                    highlightObject2(Craft.Object, 255, 255, 0, 200)
                    Craft.CanSave = true
                end
            end

            if Craft.CanSave then
                can, reason = exports['gamemode']:canPutHere(Craft.Object, (Craft.Action == 'Craft') and 'crafting' or false, Craft.ObjectName)
                cacheCanCraft = {can, reason}
                lastCheckCanCraft = getTickCount()
            end

            if not can then
                local x, y, z = getElementPosition(Craft.Object)
                local sx, sy = getScreenFromWorldPosition(x, y, z)
                if sx then
                    local w, h = dxGetTextSize(reason, 0, 1, 1, 'default-bold', false)
                    if (type(w) == 'table') then
                        w, h = unpack(w)
                    end
                    dxDrawBorderedText(reason, sx - w / 2, sy + 10, sx - w / 2 + w, sy + h + 10, tocolor(255, 255, 255, 200), 1, 'default-bold',
                        'center', 'center', false, true)
                end
                Craft.CanSave = false
            end

            if Craft.CanSave then
                highlightObject2(Craft.Object, 255, 255, 0, 200)
            else
                highlightObject2(Craft.Object, 255, 0, 0, 200)
            end

            setElementPosition(Craft.Object, x, y, z)
            setElementRotation(Craft.Object, rx, ry, rz)
        else
            local rx, ry, rz = 0, 0, (-atan2(cameraX - x2, cameraY - y2) / pi * 180) + (Craft.FrontToPlayer and 180 or 0) + Craft.Offset.rz
            setElementPosition(Craft.Object, x2, y2, z2 + Craft.Offset.z)
            setElementRotation(Craft.Object, rx, ry, rz)

            if Craft.ObjectType == 'Fundação' or Craft.ObjectType == 'Fundação Triangular' or Craft.ObjectType == 'Meia Fundação' then
                local x, y, z = getElementPosition(Craft.Object)

                local can, reason

                if not isNearToGround(x, y, z) then
                    can, reason = false, Craft.FlyingString
                else
                    can, reason = exports['gamemode']:canPutHere(Craft.Object, (Craft.Action == 'Craft') and 'crafting' or false, Craft.ObjectName)
                end

                if can then
                    Craft.CanSave = true
                    highlightObject2(Craft.Object, 255, 255, 0, 200)
                else
                    highlightObject2(Craft.Object, 255, 0, 0, 200)
                    local x, y, z = getElementPosition(Craft.Object)
                    local sx, sy = getScreenFromWorldPosition(x, y, z)
                    if sx and reason then
                        local w, h = dxGetTextSize(reason, 0, 1, 1, 'default-bold', false)
                        if (type(w) == 'table') then
                            w, h = unpack(w)
                        end
                        dxDrawBorderedText(reason, sx - w / 2, sy + 10, sx - w / 2 + w, sy + h + 10, tocolor(255, 255, 255, 200), 1, 'default-bold',
                            'center', 'center', false, true)
                    end
                end
            else
                highlightObject2(Craft.Object, 255, 0, 0, 200)

                local x, y, z = getElementPosition(Craft.Object)
                local sx, sy = getScreenFromWorldPosition(x, y, z)
                if sx then
                    local w, h = dxGetTextSize(Craft.PosicaoInvalida, 0, 1, 1, 'default-bold', false)
                    if (type(w) == 'table') then
                        w, h = unpack(w)
                    end
                    dxDrawBorderedText(Craft.PosicaoInvalida, sx - w / 2, sy + 10, sx - w / 2 + w, sy + h + 10, tocolor(255, 255, 255, 200), 1,
                        'default-bold', 'center', 'center', false, true)
                end
            end

        end
    end
end

isNearToGround = function(x, y, z)
    return not isLineOfSightClear(x, y, z + 0.5, x, y, z - 3.5, true, false, false, false, false, false, false, false)
end
