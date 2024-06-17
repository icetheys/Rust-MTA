local textures = {}

GetTexture = function(str)
    if (textures[str] ~= nil) then
        return textures[str]
    else
        local file = str and fileExists(str)
        if file then
            local tex = dxCreateTexture(str)
            if tex then
                textures[str] = tex
                return tex
            end
        end
    end
    textures[str] = false
    return false
end

GetReplaceShader = function()
    return [[
        texture gTexture;
        technique TexReplace
        {
            pass P0
            {
                Texture[0] = gTexture;
            }
        }
    ]]
end
