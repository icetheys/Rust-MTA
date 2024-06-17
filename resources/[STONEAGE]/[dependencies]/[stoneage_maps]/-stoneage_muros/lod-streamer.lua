STREAMER = {}
STREAMER_OBJECTS = {}

CHECK_DIST = 1000

addEventHandler('onClientResourceStart', root, function(res)
    STREAMER.Timer = setTimer(CheckForLODS, 500, 0)
    CheckForLODS()
end)

CheckForLODS = function()
    local px, py, pz = getElementPosition(localPlayer)
    
    if STREAMER.LastPos and (getDistanceBetweenPoints3D(px, py, pz, unpack(STREAMER.LastPos)) <= CHECK_DIST / 2) then
        return false
    end
        
    STREAMER.LastPos = {px, py, pz}
    
    for ob, lod in pairs(STREAMER_OBJECTS) do
        if isElement(ob) then
            local x, y, z = getElementPosition(ob)
            if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) > CHECK_DIST) then
                if isElement(lod) then
                    destroyElement(lod)
                    STREAMER_OBJECTS[ob] = nil
                end
            end
        else
            STREAMER_OBJECTS[ob] = nil
        end
    end
    
    for k, v in pairs(getElementsByType('object', resourceRoot)) do
        if (getElementModel(v) == 3330) and (not isElementLowLOD(v)) and (not getLowLODElement(v)) then
            if (not STREAMER_OBJECTS[v]) then
                local x, y, z = getElementPosition(v)
                if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= CHECK_DIST) then
                    local rx, ry, rz = getElementRotation(v)
                    local ob = createObject(getElementModel(v), x, y, z, rx, ry, rz, true)
                    setElementCollisionsEnabled(ob, false)
                    setLowLODElement(v, ob)
                    setElementParent(ob, v)
                    
                    STREAMER_OBJECTS[v] = ob
                end
            end
        end
    end
end
