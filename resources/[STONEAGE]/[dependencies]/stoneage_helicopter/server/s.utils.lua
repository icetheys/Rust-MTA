GetHeliSpawnPosition = function(x, y, z)
    if (x and y and z) then
        local nearestIndex, nearestDist = 0, 9999999
        for k, v in pairs(SpawnsPositions) do
            local dist = getDistanceBetweenPoints3D(x, y, z, unpack(v))
            if (dist <= nearestDist) then
                nearestIndex = k
                nearestDist = dist
            end
        end
        return unpack(SpawnsPositions[nearestIndex])
    else
        return unpack(SpawnsPositions[math.random(#SpawnsPositions)])
    end
end

FindRotation = function(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end
