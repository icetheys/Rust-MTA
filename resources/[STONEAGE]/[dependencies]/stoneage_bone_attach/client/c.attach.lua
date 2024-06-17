bone_0, bone_t, bone_f = {}, {}, {}
bone_0[1], bone_t[1], bone_f[1] = 5, nil, 6
bone_0[2], bone_t[2], bone_f[2] = 4, 5, 8
bone_0[3], bone_t[3], bone_f[3] = 3, nil, 31
bone_0[4], bone_t[4], bone_f[4] = 1, 2, 3
bone_0[5], bone_t[5], bone_f[5] = 4, 32, 5
bone_0[6], bone_t[6], bone_f[6] = 4, 22, 5
bone_0[7], bone_t[7], bone_f[7] = 32, 33, 34
bone_0[8], bone_t[8], bone_f[8] = 22, 23, 24
bone_0[9], bone_t[9], bone_f[9] = 33, 34, 32
bone_0[10], bone_t[10], bone_f[10] = 23, 24, 22
bone_0[11], bone_t[11], bone_f[11] = 34, 35, 36
bone_0[12], bone_t[12], bone_f[12] = 24, 25, 26
bone_0[13], bone_t[13], bone_f[13] = 41, 42, 43
bone_0[14], bone_t[14], bone_f[14] = 51, 52, 53
bone_0[15], bone_t[15], bone_f[15] = 42, 43, 44
bone_0[16], bone_t[16], bone_f[16] = 52, 53, 54
bone_0[17], bone_t[17], bone_f[17] = 43, 42, 44
bone_0[18], bone_t[18], bone_f[18] = 53, 52, 54
bone_0[19], bone_t[19], bone_f[19] = 44, 43, 42
bone_0[20], bone_t[20], bone_f[20] = 54, 53, 52

local eventName = getVersion().sortable >= "1.5.8-9.20704.0" and "onClientPedsProcessed" or "onClientPreRender"

addEventHandler(eventName, root, function()
    for k, v in pairs(attachments) do
        if isElement(v.ped) and isElement(v.ob) and ((getElementType(v.ped) == 'ped') or (getElementType(v.ped) == 'player')) then
            if isElementStreamedIn(v.ped) and isElementOnScreen(v.ped) then
                if (getElementInterior(v.ob) ~= getElementInterior(v.ped)) then
                    setElementInterior(v.ob, getElementInterior(v.ped))
                end
                if (getElementDimension(v.ob) ~= getElementDimension(v.ped)) then
                    setElementDimension(v.ob, getElementDimension(v.ped))
                end
                
                if (v.ped == localPlayer) then
                    local weap = getPedWeapon(localPlayer)
                    if ((weap == 34) or (weap == 35)) and getPedControlState(localPlayer, 'aim_weapon') then
                        setElementAlpha(v.ob, 0)
                    else
                        setElementAlpha(v.ob, getElementAlpha(v.ped))
                    end
                else
                    setElementAlpha(v.ob, getElementAlpha(v.ped))
                end
                
                local x, y, z = getPedBonePosition(v.ped, bone_0[v.bone])
                local xx, xy, xz, yx, yy, yz, zx, zy, zz = getBoneMatrix(v.ped, v.bone)
                
                local objx = x + (v.x * xx) + (v.y * yx) + (v.z * zx)
                local objy = y + (v.x * xy) + (v.y * yy) + (v.z * zy)
                local objz = z + (v.x * xz) + (v.y * yz) + (v.z * zz)
                
                local rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz = getMatrixFromEulerAngles(v.rx, v.ry, v.rz)
                
                local txx = (rxx * xx) + (rxy * yx) + (rxz * zx)
                local txy = (rxx * xy) + (rxy * yy) + (rxz * zy)
                local txz = (rxx * xz) + (rxy * yz) + (rxz * zz)
                local tyx = (ryx * xx) + (ryy * yx) + (ryz * zx)
                local tyy = (ryx * xy) + (ryy * yy) + (ryz * zy)
                local tyz = (ryx * xz) + (ryy * yz) + (ryz * zz)
                local tzx = (rzx * xx) + (rzy * yx) + (rzz * zx)
                local tzy = (rzx * xy) + (rzy * yy) + (rzz * zy)
                local tzz = (rzx * xz) + (rzy * yz) + (rzz * zz)
                
                local offRx, offRy, offRz = getEulerAnglesFromMatrix(txx, txy, txz, tyx, tyy, tyz, tzx, tzy, tzz)

                if (not isNaN(objx)) and (not isNaN(objy)) and (not isNaN(objz)) then
                    setElementPosition(v.ob, objx, objy, objz)
                else
                    setElementPosition(v.ob, x, y, z)
                end
                
                if (not isNaN(offRx)) and (not isNaN(offRy)) and (not isNaN(offRz)) then
                    setElementRotation(v.ob, offRx, offRy, offRz, 'ZXY')
                end
            else
                setElementPosition(v.ob, getElementPosition(v.ped))
            end
        else
            clearAttachmentData(v.ob, k)
        end
    end
end)

local nan = tostring(0 / 0)

isNaN = function(value)
    return tostring(value) == nan
end