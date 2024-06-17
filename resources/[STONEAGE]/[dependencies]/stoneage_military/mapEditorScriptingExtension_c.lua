-- FILE: 	mapEditorScriptingExtension_c.lua
-- PURPOSE:	Prevent the map editor feature set being limited by what MTA can load from a map file by adding a script file to maps
-- VERSION:	RemoveWorldObjects (v1) AutoLOD (v1) BreakableObjects (v1)
function requestLODsClient()
    triggerServerEvent('requestLODsClient', resourceRoot)
end
addEventHandler('onClientResourceStart', resourceRoot, requestLODsClient)

function setLODsClient(lodTbl)
    for i, model in ipairs(lodTbl) do
        engineSetModelLODDistance(model, 300)
    end
end
addEvent('setLODsClient', true)
addEventHandler('setLODsClient', resourceRoot, setLODsClient)

function applyBreakableState()
    for k, obj in pairs(getElementsByType('object', resourceRoot)) do
        local breakable = getElementData(obj, 'breakable')
        if breakable then
            setObjectBreakable(obj, breakable == 'true')
        end
    end
end
addEventHandler('onClientResourceStart', resourceRoot, applyBreakableState)

effect = {}
effect2 = {}
addEvent('createExplosionEffect', true)
function createExplosionEffect(time)
    for i = 1, 10 do
        local x, y, z = 3144.6708984375, -735.6123046875, 33.408813476563
        effect[i] = createEffect('carwashspray', x + math.random(-i / 2, i / 2) * 2, y + math.random(-i / 2, i / 2) * 2,
                                 z + math.random(-i / 2, i / 2) * 2, 0, 0, 0, 170, true)
        effect2[i] = createEffect('cloudfast', x + math.random(-i / 2, i / 2) * 2, y + math.random(-i / 2, i / 2) * 2,
                                  z + math.random(-i / 2, i / 2) * 2, 0, 0, 0, 170, true)
        setTimer(destroyElement, time, 1, effect[i])
        setTimer(destroyElement, time, 1, effect2[i])
    end
end
addEventHandler('createExplosionEffect', getLocalPlayer(), createExplosionEffect)

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if getElementModel(source) == 2886 then
        setObjectBreakable(source, false)
    end
end)

engineSetModelLODDistance(974, 400)
engineSetModelLODDistance(987, 400)
engineSetModelLODDistance(5145, 400)
engineSetModelLODDistance(12861, 400)
engineSetModelLODDistance(3066, 400)
engineSetModelLODDistance(8149, 400)
engineSetModelLODDistance(8150, 400)
engineSetModelLODDistance(5244, 400)
engineSetModelLODDistance(10832, 400)
engineSetModelLODDistance(3115, 400)
engineSetModelLODDistance(3095, 400)
engineSetModelLODDistance(3631, 400)
engineSetModelLODDistance(3675, 400)
engineSetModelLODDistance(6930, 400)
engineSetModelLODDistance(4100, 400)
engineSetModelLODDistance(3565, 400)
engineSetModelLODDistance(3569, 400)
engineSetModelLODDistance(3722, 400)
engineSetModelLODDistance(3572, 400)
engineSetModelLODDistance(2669, 400)
engineSetModelLODDistance(7236, 400)
