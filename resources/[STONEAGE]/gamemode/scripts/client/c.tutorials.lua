-- //------------------- TUTORIALS -------------------\\--
local _tut = {
    lastStep,
    timer,
    running = false,
    moveSpeed = 1500,
    steps = {{
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:mesa de pesquisa',
            text = 'tutorials:mesa de pesquisainfo',
            coords = {-181.2630065918, 1900.9880859375, 115.22886352539},
        }},
        objects = {
            [1917] = {-182.93952941895, 1900.5880126953, 114.06100769043},
        },
        camPos = {-182.36340332031, 1897.1669921875, 117.20980072021, -182.19763183594, 1897.9329833984, 116.58876037598},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Zonas radioativas',
            text = 'tutorials:Zonas radioativasinfo',
            coords = {192.60935974121, 1883.0526123047, 17.640625},
        }},
        objects = {},
        camPos = {104.22219848633, 2029.59765625, 102.635597229, 104.64022064209, 2028.8526611328, 102.11570739746},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Cidades',
            text = 'tutorials:Cidadesinfo',
            coords = {230.88362121582, -77.006286621094, 1.419894695282},
        }},
        objects = {},
        camPos = {78.938697814941, 61.503200531006, 117.12550354004, 79.543121337891, 60.922878265381, 116.57970428467},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Postos de gasolina',
            text = 'tutorials:Postos de gasolinainfo',
            coords = {-92.366790771484, -1167.2828369141, 2.4712164402008},
        }},
        objects = {},
        camPos = {-103.72380065918, -1144.84375, 7.2539000511169, -103.31381988525, -1145.7319335938, 7.0462012290955},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Lagos e Rios',
            text = 'tutorials:Lagos e Riosinfo',
            coords = {-771.39483642578, -1962.4152832031, 5.7384638786316},
        }},
        objects = {},
        camPos = {-900.79449462891, -1953.4733886719, 126.61170196533, -900.07952880859, -1953.4678955078, 125.91254425049},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Spawn de Itens',
            text = 'tutorials:Spawn de Itensinfo',
            coords = {-2328.3181152344, -1627.0760498047, 483.70489501953},
        }},
        objects = {
            [3593] = {-2335.2038574219, -1607.1455078125, 483.72436523438},
            [12957] = {-2331.34765625, -1615.8569335938, 483.71585083008},
            [3594] = {-2330.5405273438, -1599.7556152344, 483.76736450195},
            [1558] = {-2330.9631347656, -1615.0307617188, 484.58770751953},
            [3632] = {-2335.0778808594, -1607.1257324219, 484.40405273438},
            [1218] = {-2328.7758789063, -1600.6033935547, 483.78970336914},
            [849] = {-2333.3078613281, -1608.0803222656, 483.72344970703},
            [819] = {-2333.3078613281, -1608.0803222656, 483.72344970703 - 0.2},
            [2866] = {-2337.1723632813, -1608.7310791016, 483.7255859375},
            [808] = {-2337.1723632813, -1608.7310791016, 483.7255859375},
            [1225] = {-2337.2958984375, -1619.6771240234, 483.71212768555},
            [935] = {-2328.2622070313, -1621.6611328125, 483.71017456055},
        },
        camPos = {-2365.453125, -1604.5395507813, 494.57769775391, -2364.5397949219, -1604.8507080078, 494.31533813477},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Árvores',
            text = 'tutorials:Árvoresinfo',
            coords = {-849.72814941406, -904.67742919922, 154.24374389648},
        }},
        objects = {
            [657] = {-849.23016357422, -908.34625244141, 149.640625},
        },
        camPos = {-836.11608886719, -894.80987548828, 154.12469482422, -836.93493652344, -895.37750244141, 154.03964233398},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Minérios',
            text = 'tutorials:Minériosinfo',
            coords = {-253.15480041504, 185.39268493652, 7.9909992218018},
        }},
        objects = {
            [1304] = {-258.3330078125, 178.41046142578, 6.9682865142822},
            [905] = {-266.28018188477, 176.04513549805, 6.9375228881836},
            [2936] = {-257.5666809082, 172.15669250488, 6.3526477813721},
        },
        camPos = {-268.02319335938, 195.15130615234, 13.931799888611, -267.55465698242, 194.31744384766, 13.640013694763},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Armário',
            text = 'tutorials:Armárioinfo',
            coords = {-648.88000488281, 1531.1685791016, 84.214408874512},
        }},
        objects = {
            [3060] = {-650.6474609375, 1528.3221435547, 82.921173095703},
        },
        camPos = {-655.15600585938, 1534.068359375, 84.35359954834, -654.51440429688, 1533.3200683594, 84.184875488281},
    }, {
        waitTime = 20000,
        msgs = {{
            header = 'tutorials:Cama',
            text = 'tutorials:Camainfo',
            coords = {-481.69921875, 1808.9064941406, 130.60847473145},
        }},
        objects = {
            [1316] = {-481.1396484375, 1809.1121826172, 129.9418182373},
        },
        camPos = {-485.7864074707, 1811.7973632813, 131.6130065918, -484.99432373047, 1811.3179931641, 131.23513793945},
    }},
}

local objects = {}

function toggleTutorial(state)
    if state then
        if _tut.running then
            return
        end
        _tut.lastStep = math.random(#_tut.steps)
        -- _tut.lastStep = 1
        _tut.running = true

        jumpTutorial(_tut.lastStep)
        addEventHandler('onClientRender', root, drawTutorialTexts)
        setElementDimension(localPlayer, 1)

    else
        for k, v in pairs(objects) do
            if isElement(v) then
                -- setElementDimension(v, 0)
                -- local x, y, z = getElementPosition(v)
                -- setElementPosition(localPlayer, x, y + 1, z)
                destroyElement(v)
            end
            objects[k] = nil
        end
        setElementDimension(localPlayer, 0)
        if _tut.running then
            stopMovingCamera()
            if isTimer(_tut.timer) then
                killTimer(_tut.timer)
            end
            _tut.running = nil
            _tut.timer = nil
            removeEventHandler('onClientRender', root, drawTutorialTexts)
        end
    end
end

function jumpTutorial(id)
    local id = id + 1
    if id > #_tut.steps then
        id = 1
    end
    _tut.lastStep = id

    for k, v in pairs(objects) do
        if isElement(v) then
            destroyElement(v)
        end
        objects[k] = nil
    end

    local arr = id and _tut.steps[id]
    if arr then
        for k, v in pairs(arr.objects) do
            local x, y, z = unpack(v)
            local ob = createObject(k, x, y, z - 0.5, 0, 0, math.random(-15, 15))
            setElementDimension(ob, 1)
            objects[#objects + 1] = ob
        end
        _tut.timer = setTimer(function(id) --
            jumpTutorial(id)
        end, arr.waitTime, 1, id)

        local x, y, z, lookx, looky, lookz = unpack(arr.camPos)
        moveCamera(x, y, z, lookx, looky, lookz, _tut.moveSpeed)
    end
end

function drawTutorialTexts()
    local id = _tut.lastStep
    local arr = id and _tut.steps[id] and _tut.steps[id].msgs
    if arr then
        for k, v in pairs(arr) do
            local x, y, z = unpack(v.coords)
            local sx, sy = getScreenFromWorldPosition(x, y, z)

            if sx and sy then
                local maxW = pixels(500)

                local header = translate(v.header)
                local text = translate(v.text)

                local upperW, upperH = dxGetTextSize(header, maxW, 1.3, 1.2, font('futura:2'), true)

                if (type(upperW) == 'table') then
                    upperW, upperH = unpack(upperW)
                end

                local bottomW, bottomH = dxGetTextSize(text, maxW, 1.5, 1.1, font('futura'), true)

                if (type(bottomW) == 'table') then
                    bottomW, bottomH = unpack(bottomW)
                end

                local w = math.max(upperW, bottomW)

                dxDrawRectangle(sx, sy, w, upperH, predefinedColor('menu:color2'))
                dxDrawText(header, sx, sy, sx + w, sy + upperH, predefinedColor('menu:color1'), 1, font('futura:2'), 'center', 'center')

                dxDrawRectangle(sx, sy + upperH, w, bottomH, predefinedColor('menu:color1'))
                -- dxDrawRectangle(sx, sy + upperH, bottomW, bottomH, tocolor(math.random(255), math.random(255), math.random(255)))

                dxDrawText(text, sx + pixels(25), sy + upperH, sx + w - pixels(25), sy + upperH + bottomH, predefinedColor('menu:color2'), 1,
                    font('futura'), 'center', 'center', true, true)
            end

        end
    end
end

-- //------------------- TUTORIALS -------------------\\--
