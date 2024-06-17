attachments = {}

local serverSide = (not localPlayer)

attachElementToBone = function(ob, ped, bone, x, y, z, rx, ry, rz)
    if isElement(ob) and isElement(ped) then
        if (getElementType(ped) == 'ped') or (getElementType(ped) == 'player') then
            bone = tonumber(bone)
            if bone and (bone >= 1) and (bone <= 20) then
                table.insert(attachments, {
                    x = tonumber(x) or 0,
                    y = tonumber(y) or 0,
                    z = tonumber(z) or 0,
                    rx = tonumber(rx) or 0,
                    ry = tonumber(ry) or 0,
                    rz = tonumber(rz) or 0,

                    ped = ped,
                    ob = ob,
                    bone = bone,
                    parent = getElementParent(ob),
                    res = sourceResource,
                })

                setElementCollisionsEnabled(ob, false)

                if serverSide then
                    triggerClientEvent('attachElementToBone', root, ob, ped, bone, x, y, z, rx, ry, rz)
                    addEventHandler('onElementDestroy', ob, clearOnDestroy)    
                end

                return true
            end
        end
    end
    return false
end

clearOnDestroy = function()
    clearAttachmentData(source)
end

addCommandHandler('attachsize', function()
    iprint(serverSide and 'server' or 'client', exports['stoneage_utils']:getTableSize(attachments))
end)

addCommandHandler('attachInfo', function()
    for k, v in pairs(attachments) do
        iprint(k, v)
    end
end)

detachElementFromBone = function(ob)
    if isElement(ob) then
        clearAttachmentData(ob)
        setElementCollisionsEnabled(ob, true)
        if serverSide then
            removeEventHandler('onElementDestroy', ob, clearOnDestroy)    
            triggerClientEvent('detachElementFromBone', root, ob)
        end
        return true
    end
    return false
end

getArrayIDFromObject = function(ob)
    for k, v in pairs(attachments) do
        if (v.ob == ob) then
            return k
        end
    end
    return false
end

clearAttachmentData = function(ob, arrID)
    arrID = arrID or getArrayIDFromObject(ob)
    if arrID then
        table.remove(attachments, arrID)
    end
end

isElementAttachedToBone = function(ob)
    if isElement(ob) then
        return getArrayIDFromObject(ob) and true or false
    end
    return false
end

getElementBoneAttachmentDetails = function(ob)
    local arrID = getArrayIDFromObject(ob)
    if arrID then
        local arr = attachments[arrID]
        if arr then
            return arr.ped, arr.bone, arr.x, arr.y, arr.z, arr.rx, arr.ry, arr.rz
        end
    end
    return false
end

setElementBonePositionOffset = function(ob, x, y, z, rx, ry, rz, bone)
    local ped = getElementBoneAttachmentDetails(ob)
    if ped then
        detachElementFromBone(ob)
        return attachElementToBone(ob, ped, bone, x, y, z, rx, ry, rz)
    end
    return false
end
