local Init = function()
    Async:foreach(hospitalSpawns, function(v)
        local x, y, z = unpack(v)
        local ob = createObject(1558, x, y, z - 0.4, 0, 0, math.random(360))
        setElementData(ob, 'maxSlots', 7)
        setElementData(ob, 'obName', 'hospitalPack')

        setHospitalPackLoot(ob)
        setTimer(setHospitalPackLoot, math.random(1800000, 2700000), 0, ob)

        local dummy = createElement('hospitalPack')
        setElementPosition(dummy, x, y, z)
    end)
end
addEventHandler('onResourceStart', resourceRoot, Init)

local possibleLoots = {
    {'Bandage', 3}, 
    {'Blood Kit', 2}, 
    {'Frist Aid', 1}, 
    {'Morphine', 2}
}

setHospitalPackLoot = function(ob)
    if isElement(ob) then
        setElementRotation(ob, 0, 0, math.random(350))
        for k, v in ipairs(possibleLoots) do
            removeElementData(ob, v[1])
            setElementData(ob, v[1], math.random(0, v[2]))
        end
    end
end
