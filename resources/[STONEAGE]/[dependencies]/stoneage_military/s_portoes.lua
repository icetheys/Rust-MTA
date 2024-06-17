pos = {{
    ['colshape'] = {3130.8000488281, -588.20001220703, 9.1999998092651, 0, 0, 270},
    ['colshape2'] = {3130.6999511719, -578.70001220703, 9.3000001907349, 0, 0, 90},
    ['opened'] = {3129.6000976563, -570.70001220703, 7.4000000953674, 0, 0, 273.49951171875, 969},
    ['closed'] = {3130.1999511719, -579.20001220703, 7.4000000953674, 0, 0, 273.49951171875, 969},
}, {
    ['colshape'] = {3130.8, -603.1, 9.5000001907349, 0, 0, 180},
    ['colshape2'] = {3133.1000976563, -598.40002441406, 9.6000003814697, 0, 0, 0},
    ['opened'] = {3131.6999511719, -606.09997558594, 8.1999998092651, 0, 0, 274, 988},
    ['closed'] = {3131.5, -601.09997558594, 8.1999998092651, 0, 0, 274, 988},
}, {
    ['colshape'] = {3136.1999511719, -677.099609375, 9.3000001907349, 0, 0, 270},
    ['colshape2'] = {3137.3000488281, -687.5, 9.3999996185303, 0, 0, 90},
    ['opened'] = {3136.6999511719, -686.29998779297, 7.4000000953674, 0, 0, 273.74993896484, 969},
    ['closed'] = {3136.1999511719, -677.59997558594, 7.4000000953674, 0, 0, 273.74993896484, 969},
}, { -- 51
    ['colshape'] = {209.69999694824, 1876.7998046875, 13.49999961853, 0, 0, 90},
    ['colshape2'] = {219, 1873.8000488281, 13.60000038147, 0, 0, 0},
    ['opened'] = {201.30000305176, 1874.6999511719, 12.300000190735, 0, 0, 0, 976},
    ['closed'] = {209.89999389648, 1874.6999511719, 12.300000190735, 0, 0, 0, 976},
}, { -- lv
    ['colshape'] = {2539.6999511719, 2827.8000488281, 11.39999961853, 0, 0, 90},
    ['colshape2'] = {2539.2000488281, 2819.3000488281, 11.300000190735, 0, 0, 270},
    ['opened'] = {2539.5, 2831.999023438, 13.39999961853, 0, 0, 270, 971},
    ['closed'] = {2539.5, 2823.6999511719, 13.39999961853, 0, 0, 270, 971},
}, { -- 69
    ['colshape'] = {-1422.599609375, 488.900390625, 3.7000000476837, 0, 0, 270},
    ['colshape2'] = {-1421.400390625, 489, 3.5999999046326, 0, 0, 90},
    ['opened'] = {-1422.5999755859, 497.89999389648, 2.2000000476837, 0, 0, 90, 976},
    ['closed'] = {-1422.5999755859, 489.39999389648, 2.2000000476837, 0, 0, 90, 976},
}}

object = {}
key = {}
key2 = {}

local moving = {}
function openGate(ob, equippedID)
    local id = getElementData(ob, 'code')
    local portao = object[id]
    if moving[portao] then
        return
    end

    local x, y, z = getElementPosition(ob)
    if portao and isElement(portao) then

        local order = getElementData(source, 'keybarOrder')
        if not order or not order[equippedID] or order[equippedID].itemName ~= 'KeyCard' then
            local NOTIFICATION = exports['stoneage_notifications']
            local TRANSLATIONS = exports['stoneage_translations']
            local str = TRANSLATIONS:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATIONS:translate(source, 'KeyCard', 'name'))
            return NOTIFICATION:CreateNotification(source, str, 'error')
        end

        order[equippedID].quantity = order[equippedID].quantity - 1
        if order[equippedID].quantity <= 0 then
            order[equippedID] = nil
        end
        exports['gamemode']:onPlayerDisequipItem(equippedID, source)
        triggerClientEvent(source, 'inv:disequipCurrentKeybarItem', source)
        setElementData(source, 'keybarOrder', order)

        -- setElementData(source, 'KeyCard', (getElementData(source, 'KeyCard') or 0) - 1)
        setPedAnimation(source, 'CRIB', 'CRIB_Use_Switch', -1, false, false, false, false)
        moving[portao] = true

        setTimer(function(id)
            triggerEvent('rust:play3DSound', root, ':stoneage_military/files/open.mp3', {x, y, z}, 1, 200)
            local x, y, z = unpack(pos[id]['opened'])
            moveObject(portao, 1500, x, y, z)
            setTimer(closeGate, 10000, 1, id)
        end, 650, 1, id)
    end
end
addEvent('inserirCard', true)
addEventHandler('inserirCard', root, openGate)

function closeGate(id)
    local portao = object[id]
    if portao and isElement(portao) then
        setElementCollisionsEnabled(portao, false)

        local x, y, z = unpack(pos[id]['closed'])
        moveObject(portao, 1000, x, y, z)

        x, y, z = getElementPosition(portao)
        triggerEvent('rust:play3DSound', root, ':stoneage_military/files/close.mp3', {x, y, z}, 1, 200)

        setTimer(function(portao, id)
            if isElement(portao) then
                setElementCollisionsEnabled(portao, true)
                moving[portao] = nil
            end
        end, 1001, 1, portao, id)
    end
end

for i = 1, #pos do
    local x, y, z, rx, ry, rz, modelID = unpack(pos[i]['closed'])
    object[i] = createObject(modelID, x, y, z, rx, ry, rz)
    local x1, y1, z1, rx1, ry1, rz1 = unpack(pos[i]['colshape'])
    local x2, y2, z2, rx2, ry2, rz2 = unpack(pos[i]['colshape2'])

    key[i] = createObject(2886, x1, y1, z1, rx1, ry1, rz1)
    setElementData(key[i], 'obName', 'keyLocker')
    setElementData(key[i], 'code', i)

    key2[i] = createObject(2886, x2, y2, z2, rx2, ry2, rz2)
    setElementData(key2[i], 'obName', 'keyLocker')
    setElementData(key2[i], 'code', i)
end
