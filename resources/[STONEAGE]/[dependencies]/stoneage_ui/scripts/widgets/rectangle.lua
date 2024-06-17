--[[
    Syntax:
        CreateRectangle(x, y, w, h, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
        }
]]
function CreateRectangle(x, y, w, h, relative, parent, options)
    if type(x) ~= 'number' then error(('Couldn\'t create rectangle. (expected x, got: %s)'):format(inspect(x)), 2) end
    if type(y) ~= 'number' then error(('Couldn\'t create rectangle. (expected y, got: %s)'):format(inspect(y)), 2) end
    if type(w) ~= 'number' then error(('Couldn\'t create rectangle. (expected w, got: %s)'):format(inspect(w)), 2) end
    if type(h) ~= 'number' then error(('Couldn\'t create rectangle. (expected h, got: %s)'):format(inspect(h)), 2) end
    if type(relative) ~= 'boolean' then error(('Couldn\'t create rectangle. (expected relative as bool, got: %s)'):format(inspect(relative)), 2) end

    local rec = guiCreateStaticImage(x, y, w, h, 'files/pixel.png', relative, parent)

    local color = options and options['bgColor'] or _style['color']['background']
    color = RGBToAARRGGBB(color[1], color[2], color[3], color[4] or 255)

    guiSetProperty(rec, 'ImageColours', 'tl:' .. color .. ' tr:' .. color .. ' bl:' .. color .. ' br:' .. color)

    addHandler(sourceResourceRoot, rec)
    return rec
end

function SetRectangleColor(rec, color)
    if type(color) ~= 'table' then error(('Couldn\'t change rectangle color. (expected color as table, got: %s)'):format(inspect(color)), 2) end
    if isElement(rec) then
        if color then
            color = color or {255, 255, 255, 255}
            color = RGBToAARRGGBB(color[1], color[2], color[3], color[4] or 255)
            guiSetProperty(rec, 'ImageColours', 'tl:' .. color .. ' tr:' .. color .. ' bl:' .. color .. ' br:' .. color)
        end
    end
end
