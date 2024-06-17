rad = math.rad
cos = math.cos
sin = math.sin

sW, sH = 640, 480
sW, sH = guiGetScreenSize()

CanHandleMenu = function()
    local equipped = getElementData(localPlayer, 'equippedItem')

    if equipped == 'Planner' then
        return false
    end

    local GAMEMODE = exports['gamemode']

    local weapons = {
        [0] = true,
        [1] = true,
    }

    if (not weapons[getPedWeaponSlot(localPlayer)]) then
        return false
    end

    -- if (equipped and GAMEMODE:isWeapon(equipped) and GAMEMODE:getItemType(equipped) ~= 'weapon-melee') then
    --     return false
    -- end

    if GAMEMODE:isPlayerCrafting() or GAMEMODE:isShowingInventory() then
        return false
    end

    if getElementData(localPlayer, 'desmaiado') or getElementData(localPlayer, 'editingObj') then
        return false
    end

    return true
end

translate = function(...)
    return exports['stoneage_translations']:translate(...)
end

table.size = function(arr)
    local q = 0
    for k in pairs(arr) do
        q = q + 1
    end
    return q
end

local textures = {}

function getTexture(str)
    if str then
        str = ('assets/icons/%s'):format(str)
        if textures[str] then
            return textures[str]
        else
            local file = str and fileExists(str)
            if file then
                local tex = dxCreateTexture(str, 'dxt3', true, 'clamp')
                if tex then
                    textures[str] = tex
                    return textures[str]
                end
            end
        end
        textures[str] = 'assets/icons/info.png'
    end
    return 'assets/icons/info.png'
end

isAdmin = function(p)
    return getElementData(p, 'staffRole')
end
