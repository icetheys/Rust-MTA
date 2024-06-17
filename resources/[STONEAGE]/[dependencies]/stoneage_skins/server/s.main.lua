local Skins = {}

local Init = function()
    local ob = createObject(1773, 0, 0, 3)

    setTimer(ApplySkin, 500, 1, ob, 'skin_fornalha_1')
    setTimer(RemoveSkin, 1500, 1, ob)
    setTimer(ApplySkin, 3500, 1, ob, 'skin_fornalha_1')
end
-- addEventHandler('onResourceStart', resourceRoot, Init)

ApplySkin = function(ob, skinName)
    if isElement(ob) and AVAIABLE_SKINS[skinName] then
        if Skins[ob] then
            RemoveSkin(ob)
        end
        Skins[ob] = skinName
        setElementData(ob, 'Skin', skinName)
        addEventHandler('onElementDestroy', ob, OnElementDestroy)
        triggerClientEvent(root, 'ApplySkin', resourceRoot, ob, skinName)
        return true
    end
    return false
end

RemoveSkin = function(ob)
    if Skins[ob] then
        Skins[ob] = nil
        if isElement(ob) then
            removeElementData(ob, 'Skin')
            removeEventHandler('onElementDestroy', ob, OnElementDestroy)
        end
        triggerClientEvent(root, 'RemoveSkin', resourceRoot, ob)
        return true
    end
    return false
end

OnElementDestroy = function()
    RemoveSkin(source)
end

GetAppliedSkinName = function(ob)
    return Skins[ob] or false
end

RequestSkins = function()
    triggerClientEvent(client, 'ReceiveSkins', client, Skins)
end
addEvent('RequestSkins', true)
addEventHandler('RequestSkins', root, RequestSkins)
