Render = function()
    local maxDistance = 20
    local maxDistanceIcon = 200
    
    if getElementData(localPlayer, 'distanciaExtraNametag') then
        maxDistance = 500
    end
    
    setPedTargetingMarkerEnabled(false)
    
    local staff = getElementData(localPlayer, 'staffRole')
    
    local px, py, pz = getElementPosition(getCamera())
    for k, v in ipairs(getElementsByType('player', root, true)) do
        if (v ~= localPlayer) then
            local x, y, z = getPedBonePosition(v, 8)
            local dist = math.floor(getDistanceBetweenPoints3D(x, y, z, px, py, pz))

            local pedGroup = getElementData(v, 'Group')

            local sameGroup = pedGroup and pedGroup == getElementData(localPlayer, 'Group')

            if (getPedTarget(localPlayer) == v) or (dist <= 0.9) or staff or sameGroup then
                local sx, sy = getScreenFromWorldPosition(x, y, z + 0.4)
                if (sx and sy) then
                    
                    local r, g, b = 200, 200, 200

                    if Talking[v] then
                        r, g, b = 0, 150, 200
                    end
                    
                    local maxAlpha = staff and 255 or getElementAlpha(v)
                    
                    local str = getPlayerName(v)
                    
                    if staff then
                        local group = getElementData(v, 'Group')
                        if group then
                            str = str .. (' (%s)'):format(group)
                        end
                    end
                    
                    if sameGroup then
                        maxDistance = 10000
                        str = str .. ('\n%sm'):format(dist)
                    end
                    
                    local alpha = math.floor(interpolateBetween(maxAlpha, 0, 0, 0, 0, 0, dist / maxDistance, 'Linear'))
                    
                    if getElementData(v, 'Flying') and (not staff) then
                        alpha = 0
                    end
                    
                    local textW = dxGetTextWidth(str)
                    dxDrawBorderedText(str, sx - textW, sy, sx + textW, sy + 20, tocolor(r, g, b, alpha), 1, 'default-bold', 'center', 'center')
                    
                    if pedGroup and (pedGroup == getElementData(localPlayer, 'Group')) then
                        local alphaIcon = math.floor(interpolateBetween(maxAlpha, 0, 0, 0, 0, 0, dist / maxDistanceIcon, 'Linear'))
                        dxDrawImage(sx - (24 / 2), sy - (24 / 2) - 10, 24, 24, 'team.png', 0, 0, 0, tocolor(255, 255, 255, alphaIcon))
                    end
                    
                    if staff and getKeyState('x') then
                        local w, h = 200, 15
                        local padding = 3
                        
                        local health = getElementData(localPlayer, 'blood')
                        local maxHealth = 15000
                        
                        local percent = (health / maxHealth)
                        
                        dxDrawRectangle(sx - w / 2, sy - (h / 2) - 30, w, h, tocolor(30, 30, 30))
                        dxDrawRectangle(sx - w / 2 + padding, sy - (h / 2) - 30 + padding, math.min(w, w * percent) - padding * 2, h - padding * 2, tocolor(106, 125, 65))
                    
                    end
                
                end
            end
        end
    end
end

function dxDrawBorderedText(text, x, y, w, h, color, ...)
    local uncolored = text:gsub('#%x%x%x%x%x%x', '')
    local alpha = bitExtract(color, 24, 8)
    for ox = -1, 1 do
        for oY = -1, 1 do
            dxDrawText(uncolored, x + ox, y + oY, w + ox, h + oY, tocolor(0, 0, 0, alpha), ...)
        end
    end
    dxDrawText(text, x, y, w, h, color, ...)
end
