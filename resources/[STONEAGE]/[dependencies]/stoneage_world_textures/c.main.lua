local Replaces = {}

local AlreadyReplaced = false

toggleWorldTextures = function(state)
    if (state and AlreadyReplaced) or (not state and not AlreadyReplaced) then
        return
    end
    AlreadyReplaced = state
    
    if state then
        for id, replaceTable in pairs(TEXTURES) do
            Replaces[id] = {
                texture = dxCreateTexture(('media/%s.png'):format(id), 'dxt3'),
                shader = dxCreateShader('fx/world.fx'),
            }
            for k, v in ipairs(replaceTable) do
                dxSetShaderValue(Replaces[id].shader, 't', Replaces[id].texture)
                engineApplyShaderToWorldTexture(Replaces[id].shader, v)
            end
        end
    else
        for id, replaceTable in pairs(TEXTURES) do
            if Replaces[id] then
                for k, v in ipairs(replaceTable) do
                    engineRemoveShaderFromWorldTexture(Replaces[id].shader, v)
                end
                if isElement(Replaces[id].texture) then
                    destroyElement(Replaces[id].texture)
                end
                if isElement(Replaces[id].shader) then
                    destroyElement(Replaces[id].shader)
                end
                Replaces[id] = nil
            end
        end
    end
end