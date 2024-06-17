local attachs = {}
local weaponAttachments = {}
local defenseAttachments = {}

-- //------------------- ATTACH ITEM TO BONE -------------------\\--
function attachItemToBone(itemName, ped)
    if not isElement(ped) then
        return
    end
    local attachInfo = getPlayerDataSetting(itemName, 'attach')
    if attachInfo then
        detachItemFromBone(itemName, ped)
        local px, py, pz = getElementPosition(ped)
        local model = attachInfo.modelID
        local bone = attachInfo.bone
        local scale = attachInfo.scale
        local x, y, z, rx, ry, rz = unpack(attachInfo.pos)
        local ob = createObject(model, px + x, py + y, pz + z)
        setElementCollisionsEnabled(ob, false)
        setObjectScale(ob, scale)

        if not attachs[ped] then
            attachs[ped] = {}
        end
        attachs[ped][itemName] = ob

        BONE_ATTACH:attachElementToBone(ob, ped, bone, x, y, z, rx, ry, rz)
        setElementData(ped, 'rust:attachments', attachs[ped])
    end
end
-- //------------------- ATTACH ITEM TO BONE -------------------\\--

-- //------------------- REMOVE SINGLE ATTACH -------------------\\--
function detachItemFromBone(itemName, ped)
    if ped then
        if attachs[ped] and attachs[ped][itemName] then
            BONE_ATTACH:detachElementFromBone(attachs[ped][itemName])
            if isElement(attachs[ped][itemName]) then
                destroyElement(attachs[ped][itemName])
            end
            attachs[ped][itemName] = nil
            if table.size(attachs[ped]) == 0 then
                attachs[ped] = nil
            end

            setElementData(ped, 'rust:attachments', attachs[ped])
        end
    end
end
loadEvent('detachItemFromBone', root, detachItemFromBone)
-- //------------------- REMOVE SINGLE ATTACH -------------------\\--

-- //------------------- EDIT ATTACH -------------------\\--
function setAttachOffsets(itemName, ped, x, y, z, rx, ry, rz, bone)
    if ped and attachs[ped] and attachs[ped][itemName] then
        return BONE_ATTACH:setElementBonePositionOffset(attachs[ped][itemName], x, y, z, rx, ry, rz, bone)
    end
    return false
end

function setAttachModel(itemName, ped, modelID)
    if ped and attachs[ped] and attachs[ped][itemName] then
        setElementModel(attachs[ped][itemName], modelID)
    end
    return false
end
-- //------------------- EDIT ATTACH -------------------\\--

-- //------------------- REMOVE ALL ATTACHES -------------------\\--
function removeAllAttachesFromBone(ped)
    if attachs[ped] then
        for itemName in pairs(attachs[ped]) do
            detachItemFromBone(itemName, ped)
        end
    end
    if weaponAttachments[ped] then
        for weaponType in pairs(weaponAttachments[ped]) do
            detachWeaponFromBone(weaponType, ped)
        end
    end
    if defenseAttachments[ped] then
        for defenseItem in pairs(defenseAttachments[ped]) do
            detachDefenseFromBone(defenseItem, ped)
        end
    end
end
-- //------------------- REMOVE ALL ATTACHES -------------------\\--

-- //------------------- REMOVE ATTACHES ON QUIT -------------------\\--
addEventHandler('onPlayerQuit', root, function()
    removeAllAttachesFromBone(source)
end)
-- //------------------- REMOVE ATTACHES ON QUIT -------------------\\--

-- //------------------- DETECT INVENTORY CHANGE -------------------\\--
addEventHandler('onElementDataChange', root, function(key, old, new)
    if getElementType(source) == 'player' then
        if isWeapon(key) then
            local itemType = getItemType(key)
            if (new or 0) > (old or 0) then
                attachWeaponToBody(key, source)
            else
                if weaponAttachments[source] and weaponAttachments[source][itemType] and weaponAttachments[source][itemType].itemName == key then
                    detachWeaponFromBone(itemType, source)

                    setTimer(function(player)
                        if not isElement(player) then
                            return
                        end

                        for k, v in pairs(getElementData(player, 'invOrder') or {}) do
                            if getItemType(v.itemName) == itemType then
                                attachWeaponToBody(v.itemName, player)
                                break
                            end
                        end

                        for k, v in pairs(getElementData(player, 'keybarOrder') or {}) do
                            if getItemType(v.itemName) == itemType then
                                attachWeaponToBody(v.itemName, player)
                                break
                            end
                        end
                    end, 500, 1, source)

                end
            end
        end
    end
end)
-- //------------------- DETECT INVENTORY CHANGE -------------------\\--

-- //------------------- ATTACH WEAPONS TO BODY -------------------\\--
function attachWeaponToBody(weaponName, ped)
    if not isElement(ped) then
        return
    end
    local attachInfo = getPlayerDataSetting(weaponName, 'attachBackward')
    if attachInfo then
        local itemType = getItemType(weaponName)
        detachWeaponFromBone(itemType, ped)

        local px, py, pz = getElementPosition(ped)
        local model = attachInfo.modelID
        local bone = attachInfo.bone
        local scale = attachInfo.scale
        local x, y, z, rx, ry, rz = unpack(attachInfo.pos)
        local ob = createObject(model, px + x, py + y, pz + z)
        setElementCollisionsEnabled(ob, false)
        setObjectScale(ob, scale)

        if not weaponAttachments[ped] then
            weaponAttachments[ped] = {}
        end

        weaponAttachments[ped][itemType] = {
            ob = ob,
            itemName = weaponName,
        }

        BONE_ATTACH:attachElementToBone(ob, ped, bone, x, y, z, rx, ry, rz)
    end
end
-- //------------------- ATTACH WEAPONS TO BODY -------------------\\--

-- //------------------- DETACH WEAPON FROM BODY -------------------\\--
function detachWeaponFromBone(weaponType, ped)
    if weaponAttachments[ped] and weaponAttachments[ped][weaponType] then
        BONE_ATTACH:detachElementFromBone(weaponAttachments[ped][weaponType].ob)
        if isElement(weaponAttachments[ped][weaponType].ob) then
            destroyElement(weaponAttachments[ped][weaponType].ob)
        end
        weaponAttachments[ped][weaponType] = nil
        if table.size(weaponAttachments[ped]) == 0 then
            weaponAttachments[ped] = nil
        end
    end
end
-- //------------------- DETACH WEAPON FROM BODY -------------------\\--

-- //------------------- ATTACH DEFENSE ITEMS TO BODY -------------------\\--
function attachDefenseToBody(itemName, ped)
    if not isElement(ped) then
        return
    end
    local attachInfo = getPlayerDataSetting(itemName, 'attachDefense')
    if attachInfo then
        detachDefenseFromBone(itemName, ped)

        local px, py, pz = getElementPosition(ped)
        local model = attachInfo.modelID
        local bone = attachInfo.bone
        local scale = attachInfo.scale
        local x, y, z, rx, ry, rz = unpack(attachInfo.pos)
        local ob = createObject(model, px + x, py + y, pz + z)
        setObjectScale(ob, scale)

        if not defenseAttachments[ped] then
            defenseAttachments[ped] = {}
        end

        defenseAttachments[ped][itemName] = ob

        BONE_ATTACH:attachElementToBone(ob, ped, bone, x, y, z, rx, ry, rz)

    end
end
-- //------------------- ATTACH DEFENSE ITEMS TO BODY -------------------\\--

-- //------------------- DETTACH DEFENSE ITEMS FROM BODY -------------------\\--
function detachDefenseFromBone(itemName, ped)
    if ped then
        if defenseAttachments[ped] and defenseAttachments[ped][itemName] then
            BONE_ATTACH:detachElementFromBone(defenseAttachments[ped][itemName])
            if isElement(defenseAttachments[ped][itemName]) then
                destroyElement(defenseAttachments[ped][itemName])
            end
            defenseAttachments[ped][itemName] = nil
            if table.size(defenseAttachments[ped]) == 0 then
                defenseAttachments[ped] = nil
            end
        end
    end
end
-- //------------------- DETTACH DEFENSE ITEMS FROM BODY -------------------\\--