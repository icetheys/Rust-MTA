local Shader = {shader, currentObject, r, g, b, a}

addEventHandler('onClientResourceStart', resourceRoot, function()
    Shader.shader = dxCreateShader(getHighLightCode())
end)

function highlightObject(ob, color)
    if Shader.shader then
        if (color) then
            local r, g, b, a = unpack(color)
            if (Shader.currentObject == ob) then
                if (Shader.r == r) and (Shader.g == g) and (Shader.b == b) and (Shader.a == a) then
                    return
                end
            end
        else
            Shader.r = nil
            Shader.g = nil
            Shader.b = nil
            Shader.a = nil
        end

        if Shader.currentObject and isElement(Shader.currentObject) then
            if Shader.currentObject ~= ob then
                engineRemoveShaderFromWorldTexture(Shader.shader, '*', Shader.currentObject)
            end
        end
        
        if ob and isElement(ob) then
            if (getElementType(ob) == 'vehicle') then
                return
            end
            if type(color) == 'table' then
                local r, g, b, a = unpack(color)
                dxSetShaderValue(Shader.shader, 'gColor', r, g, b, a)
                Shader.r = r
                Shader.g = g
                Shader.b = b
                Shader.a = a
            end

            engineApplyShaderToWorldTexture(Shader.shader, '*', ob)

            engineRemoveShaderFromWorldTexture(Shader.shader, 'pinelo128', ob)
            engineRemoveShaderFromWorldTexture(Shader.shader, 'veg_bush2', ob)

            Shader.currentObject = ob
        end
        return true
    end
    return false
end
