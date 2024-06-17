local Skins = {}

local Init = function()
    triggerServerEvent('RequestSkins', localPlayer)
    -- addEventHandler('onClientRender', root, function()
    --     dxDrawText(inspect(Skins), 1200, 200)
    -- end)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

ReceiveSkins = function(received)
    for k, v in pairs(received) do
        ApplySkin(k, v)
    end
end
addEvent('ReceiveSkins', true)
addEventHandler('ReceiveSkins', localPlayer, ReceiveSkins)

ApplySkin = function(ob, skinName)
    if isElement(ob) and AVAIABLE_SKINS[skinName] then
        Skins[ob] = {
            SkinName = skinName,
            Shaders = {}
        }
        for k, v in pairs(AVAIABLE_SKINS[skinName].Apply) do
            local texture = GetTexture(('assets/%s/%s.png'):format(skinName, v))
            if texture then
                local Shader = dxCreateShader(GetReplaceShader())
                dxSetShaderValue(Shader, "gTexture", texture)
                engineApplyShaderToWorldTexture(Shader, v, ob)
                Skins[ob].Shaders[v] = Shader
            end
        end
        return true
    end
    return false
end
addEvent('ApplySkin', true)
addEventHandler('ApplySkin', resourceRoot, ApplySkin)

GetAppliedSkinName = function(ob)
    return Skins[ob] and Skins[ob].SkinName or false
end

RemoveSkin = function(ob)
    if Skins[ob] then
        for k, v in pairs(Skins[ob].Shaders) do
            if isElement(v) then
                destroyElement(v)
            end
        end
        Skins[ob] = nil
        return true
    end
    return false
end
addEvent('RemoveSkin', true)
addEventHandler('RemoveSkin', resourceRoot, RemoveSkin)
