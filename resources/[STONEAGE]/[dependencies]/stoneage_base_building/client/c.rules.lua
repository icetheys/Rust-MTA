local offsets = {}

-- local debugMode = true

------------------------- FUNDAÇÃO -------------------------
offsets['Fundação'] = {
    ['World'] = {0, 0, 0.025},
    ['Fundação'] = {
        ['front'] = {0, 4.45, 0, 0, 0, 0},
        ['right'] = {4.45, 0, 0, 0, 0, 0},
        ['back'] = {0, -4.45, 0, 0, 0, 0},
        ['left'] = {-4.45, 0, 0, 0, 0, 0},
    },
    ['Fundação Triangular'] = {
        ['front'] = {0, 3.5, 0, 0, 0, 180},
        ['right'] = {3.5, 0, 0, 0, 0, 90},
        ['back'] = {0, -3.5, 0, 0, 0, 0},
        ['left'] = {-3.5, 0, 0, 0, 0, 270},
    },
    ['Meia Fundação'] = {
        ['front'] = {0, 3.375, 0, 0, 0, 180},
        ['right'] = {3.375, 0, 0, 0, 0, 90},
        ['back'] = {0, -3.375, 0, 0, 0, 0},
        ['left'] = {-3.375, 0, 0, 0, 0, 270},
    },
    ['Parede'] = {
        ['front'] = {0, 2.225, 0.05, 0, 0, 0},
        ['right'] = {2.225, 0, 0.05, 0, 0, 270},
        ['back'] = {0, -2.225, 0.05, 0, 0, 180},
        ['left'] = {-2.225, 0, 0.05, 0, 0, 90},
    },
    ['Porta'] = {
        ['front'] = {-0.565, 2.2, 0.05, 0, 0, 0},
        ['right'] = {2.2, 0.565, 0.05, 0, 0, 270},
        ['back'] = {0.565, -2.2, 0.05, 0, 0, 180},
        ['left'] = {-2.2, -0.565, 0.05, 0, 0, 90},
    },
    ['Escadas'] = {
        ['front'] = {0, 0.005, 0.01, 0, 0, 180},
        ['right'] = {0.005, 0, 0.01, 0, 0, 90},
        ['back'] = {0, -0.005, 0.01, 0, 0, 0},
        ['left'] = {-0.005, 0, 0.01, 0, 0, 270},
    },
}
offsets['Fundação']['Parede Para Porta'] = offsets['Fundação']['Parede']
offsets['Fundação']['Janela'] = offsets['Fundação']['Parede']
offsets['Fundação']['Portão'] = offsets['Fundação']['Parede']
------------------------- FUNDAÇÃO -------------------------

------------------------- FUNDAÇÃO TRIANGULAR -------------------------
offsets['Fundação Triangular'] = {
    ['World'] = {0, 0, 0.025},
    ['Fundação'] = {
        ['front'] = {0, 3.5, 0, 0, 0, 0},
        ['right'] = {3.05, -1.735, 0, 0, 0, 60},
        ['left'] = {-3.05, -1.735, -0.0, 0, 0, 120},
    },
    ['Fundação Triangular'] = {
        ['front'] = {0, 2.55, 0, 0, 0, 180},
        ['right'] = {2.225, -1.285, 0, 0, 0, 180},
        ['left'] = {-2.225, -1.285, 0, 0, 0, 180},
    },
    ['Meia Fundação'] = {
        ['front'] = {0, 2.39, 0, 0, 0, 0},
        ['right'] = {2.1, -1.2, 0, 0, 0, 60},
        ['left'] = {-2.1, -1.2, 0, 0, 0, 120},
    },
    ['Parede'] = {
        ['front'] = {0, 1.3, 0.05, 0, 0, 0},
        ['right'] = {1.15, -0.68, 0.05, 0, 0, 60},
        ['left'] = {-1.15, -0.6, 0.05, 0, 0, 120},
    },
    ['Porta'] = {
        ['front'] = {-0.565, 1.3, 0, 0, 0, 0},
        ['right'] = {1.4, -0.15, 0, 0, 0, 240},
        ['left'] = {-1.4, -0.05, 0, 0, 0, 300},
    },
}
offsets['Fundação Triangular']['Parede Para Porta'] = offsets['Fundação Triangular']['Parede']
offsets['Fundação Triangular']['Janela'] = offsets['Fundação Triangular']['Parede']
offsets['Fundação Triangular']['Portão'] = offsets['Fundação Triangular']['Parede']
------------------------- FUNDAÇÃO TRIANGULAR -------------------------

------------------------- MEIA FUNDAÇÃO -------------------------
offsets['Meia Fundação'] = {
    ['World'] = {0, 0, 0.025},
    ['Fundação'] = {
        ['front'] = {0, 3.35, 0, 0, 0, 0},
        ['back'] = {0, -3.35, 0, 0, 0, 0},
    },
    ['Fundação Triangular'] = {
        ['front'] = {0, 2.425, 0, 0, 0, 180},
        ['back'] = {0, -2.385, 0, 0, 0, 0},
    },
    ['Meia Fundação'] = {
        ['front'] = {0, 2.085, 0, 0, 0, 0},
        ['right'] = {4.45, 0, 0, 0, 0, 0},
        ['back'] = {0, -2.2, 0, 0, 0, 0},
        ['left'] = {-4.45, 0, 0, 0, 0, 0},
    },
    ['Parede'] = {
        ['front'] = {0, 1.1, 0.005, 0, 0, 0},
        ['back'] = {0, -1.1, 0.005, 0, 0, 180},
    },
    ['Porta'] = {
        ['front'] = {-0.565, 0.985, 0.005, 0, 0, 0},
        ['back'] = {0.565, -0.985, 0.005, 0, 0, 180},
    },
    ['Meia Parede'] = {
        ['left'] = {-2.225, 0, 0.005, 0, 0, 90},
        ['right'] = {2.225, 0, 0.005, 0, 0, 270},
    },
}
offsets['Meia Fundação']['Parede Para Porta'] = offsets['Meia Fundação']['Parede']
offsets['Meia Fundação']['Janela'] = offsets['Meia Fundação']['Parede']
offsets['Meia Fundação']['Portão'] = offsets['Meia Fundação']['Parede']
------------------------- MEIA FUNDAÇÃO -------------------------

------------------------- PAREDES -------------------------
offsets['Parede'] = {
    ['Fundação'] = {
        ['front'] = {0, 2.25, 0, 0, 0, 0},
        ['back'] = {0, -2.25, 0, 0, 0, 0},
    },
    ['Fundação Triangular'] = {
        ['front'] = {0, 1.27, 0, 0, 0, 180},
        ['back'] = {0, -1.27, 0, 0, 0, 0},
    },
    ['Meia Fundação'] = {
        ['front'] = {0, 1.15, 0, 0, 0, 180},
        ['back'] = {0, -1.15, 0, 0, 0, 0},
    },
    ['Teto'] = {
        ['front'] = {0, 2.25, 3.5, 0, 0, 0},
        ['back'] = {0, -2.25, 3.5, 0, 0, 0},
    },
    ['Parede'] = {
        ['left'] = {-4.5, 0, 0, 0, 0, 0},
        ['right'] = {4.5, 0, 0, 0, 0, 0},
    },
    ['Escadas'] = {
        ['front'] = {0.775, 2.35, 0.01, 0, 0, 180},
        ['back'] = {-0.775, -2.35, 0.01, 0, 0, 0},
    },
    ['Meia Parede'] = {
        ['left'] = {-3.375, 0, 0, 0, 0, 180},
        ['right'] = {3.375, 0, 0, 0, 0, 0},
    },
    ['Meio Teto'] = {
        ['front'] = {0, 1.175, 3.5, 0, 0, 180},
        ['back'] = {0, -1.175, 3.5, 0, 0, 0},
    },
    ['Teto Triangular'] = {
        ['front'] = {0, 1.25, 3.5, 0, 0, 180},
        ['back'] = {0, -1.25, 3.5, 0, 0, 0},
    },
}
offsets['Parede']['Janela'] = offsets['Parede']['Parede']
offsets['Parede']['Portão'] = offsets['Parede']['Parede']
offsets['Parede']['Floorport'] = offsets['Parede']['Teto']

offsets['Janela'] = offsets['Parede']
offsets['Portão'] = offsets['Parede']

------------------------- MEIA PAREDE -------------------------
offsets['Meia Parede'] = {
    ['Meio Teto'] = {
        ['front'] = {0, 2.275, 3.5, 0, 0, 90},
        ['back'] = {0, -2.25, 3.5, 0, 0, 270},
    },
    ['Parede'] = {
        ['left'] = {-3.37, 0, 0, 0, 0, 0},
        ['right'] = {3.42, 0, 0, 0, 0, 0},
    },
}
------------------------- MEIA PAREDE -------------------------

offsets['Parede Para Porta'] = {}
for k, v in pairs(offsets['Parede']) do
    offsets['Parede Para Porta'][k] = v
end
offsets['Parede Para Porta']['Porta'] = {
    ['right'] = {-0.565, 0, 0.05, 0, 0, 0},
}
------------------------- PAREDES -------------------------

------------------------- TETOS -------------------------
offsets['Teto'] = {}
for k, v in pairs(offsets['Fundação']) do
    offsets['Teto'][k] = v
end

offsets['Teto']['Meio Teto'] = offsets['Fundação']['Meia Fundação']
offsets['Teto']['Teto Triangular'] = offsets['Fundação']['Fundação Triangular']

offsets['Teto']['Fundação'] = nil
offsets['Teto']['Fundação Triangular'] = nil
offsets['Teto']['Meia Fundação'] = nil

offsets['Teto']['Teto'] = offsets['Fundação']['Fundação']

offsets['Floorport'] = offsets['Teto']

offsets['Meio Teto'] = {}
for k, v in pairs(offsets['Meia Fundação']) do
    offsets['Meio Teto'][k] = v
end

offsets['Meio Teto']['Fundação'] = nil
offsets['Meio Teto']['Fundação Triangular'] = nil
offsets['Meio Teto']['Meia Fundação'] = nil
offsets['Meio Teto']['Meio Teto'] = offsets['Meia Fundação']['Meia Fundação']


offsets['Teto Triangular'] = {}
for k, v in pairs(offsets['Fundação Triangular']) do
    offsets['Teto Triangular'][k] = v
end

offsets['Teto Triangular']['Teto Triangular'] = offsets['Fundação Triangular']['Fundação Triangular']

offsets['Teto Triangular']['Fundação'] = nil
offsets['Teto Triangular']['Fundação Triangular'] = nil
offsets['Teto Triangular']['Meia Fundação'] = nil
------------------------- TETOS -------------------------

local directionNameFromID = {
    [1] = 'front',
    [2] = 'right',
    [3] = 'back',
    [4] = 'left',
}

cantRotateOb = {
    ['Porta'] = true,
    ['Fundação Triangular'] = true,
    ['Teto Triangular'] = true,
}

function canAttachObjects(ob1, ob2, obName)
    local ob2Name = getElementData(ob2, 'baseObject') and getElementData(ob2, 'obType')
    if ob2Name then
        local direction = directionSnap(ob1, ob2, obName, ob2Name)

        local offsets = getOffsets(obName, ob2Name, direction)

        if debugMode then
            dxDrawBorderedText(inspect {
                attachedTo = ob2Name,
                obName = obName,
                offsets = offsets or 'Não configurado.',
                direction = directionNameFromID[direction] or 'Nenhuma.',
            }, sW * 0.8, sH * 0.2, sW, sH, white, 1, 'default-bold', 'left', 'top', true, true)
        end

        if offsets then
            local offsetX, offsetY, offsetZ, offsetRx, offsetRy, offsetRz = unpack(offsets)

            if not Craft.FrontToPlayer and not cantRotateOb[obName] then
                offsetRz = offsetRz + 180
            end
            local originalOffsetZ = (offsetRz or 0)
            local rx, ry, rz = getElementRotation(ob2)

            offsetX, offsetY, offsetZ = getPositionFromElementOffset(ob2, offsetX, offsetY, offsetZ)
            offsetRx, offsetRy, offsetRz = rx + (offsetRx or 0), ry + (offsetRy or 0), rz + (offsetRz or 0)

            local _, _, ob2z = getElementPosition(ob2)

            if offsetZ == ob2z then
                local offsetCheck = 0.5
                local hit, _, _, _, element = processLineOfSight(offsetX, offsetY, offsetZ + offsetCheck, offsetX, offsetY, offsetZ - offsetCheck,
                                                                 false, false, false, true, false, false, false, false, ob2)
                if hit and not isElementLowLOD(element) then
                    return false
                end
            end

            offsetZ = offsetZ + (math.random(2) == 1 and -0.005 or 0.005)

            for k, v in ipairs(getElementsWithinRange(offsetX, offsetY, offsetZ, 10, 'object')) do
                if (v ~= ob1) and (v ~= ob2) and (not isElementLowLOD(v)) and getElementData(v, 'baseObject') then
                    if (obName == 'Porta' and getElementData(v, 'obType') == 'Parede Para Porta') then

                    else
                        if getDistanceBetweenPoints3D(offsetX, offsetY, offsetZ, getElementPosition(v)) <= 1 then
                            return false
                        end
                    end
                end
            end
            return offsetX, offsetY, offsetZ, offsetRx, offsetRy, offsetRz, originalOffsetZ
        end
    end
    return false
end

updateAttachPos = function(_x1, _y1, _z1, _rx1, _ry1, _rz1)
    x1, y1, z1, rx1, ry1, rz1 = _x1, _y1, _z1, _rx1, _ry1, _rz1
end

function getOffsets(obName1, obName2, direction)
    if obName1 and obName2 then
        if offsets[obName2] then
            if offsets[obName2][obName1] then
                if offsets[obName2][obName1] then
                    return offsets[obName2][obName1][directionNameFromID[direction]] or false
                end
            end
        end
    end
    return false
end

function directionSnap(ob, ob2, obName, obName2)
    local x, y, z = getElementPosition(ob)
    local x1, y1, z1 = getElementPosition(ob2)

    local relativePos = {
        x = x - x1,
        y = y - y1,
    }

    local vectors = {
        [1] = ob2.matrix.forward,
        [2] = ob2.matrix.right,
        [3] = -ob2.matrix.forward,
        [4] = -ob2.matrix.right,
    }

    local minDistance, minIndex = 1000, 0

    for i = 1, 4 do
        if offsets[obName2] and offsets[obName2][obName] and offsets[obName2][obName][directionNameFromID[i]] then
            local point = vectors[i]
            if debugMode then
                local x, y, z = x1 + point.x, y1 + point.y, z1 + point.z
                dxDrawLine3D(x, y, z, x, y, z + 1, tocolor(255, 255, 255, 255), 1)
                local wx, wy = getScreenFromWorldPosition(x, y, z + 1)
                if wx then
                    dxDrawBorderedText(directionNameFromID[i], wx + 10, wy, 0, 0)
                end
            end
            local dist = getDistanceBetweenPoints2D(point.x, point.y, relativePos.x, relativePos.y)
            if dist < minDistance then
                minDistance = dist
                minIndex = i
            end
        end
    end
    if debugMode and vectors[minIndex] then
        local endx, endy, endz = vectors[minIndex].x, vectors[minIndex].y, z1
        dxDrawLine3D(x, y, z, x, y, z + 1, tocolor(255, 255, 255, 255), 1)
        dxDrawLine3D(x, y, z + 1, x1 + endx, y1 + endy, endz + 1, tocolor(255, 255, 255, 255), 1)
    end
    return minIndex
end

getWorldOffsets = function(obName)
    local offX, offY, offZ, offRX, offRY, offRz = 0, 0, 0, 0, 0, 0
    if offsets[obName] and offsets[obName]['World'] then
        offX, offY, offZ, offRX, offRY, offRz = unpack(offsets[obName]['World'])
    end
    return offX, offY, offZ, offRX, offRY, offRz
end
