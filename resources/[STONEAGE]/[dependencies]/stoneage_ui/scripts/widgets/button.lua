--[[
    Syntax:
        CreateButton(x, y, w, h, text, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            font: {r,g,b},
            text-align-x: string,
            text-align-y: string,
            ignoreCollapse: bool,
        }
]]
function CreateButton(x, y, w, h, text, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create button. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create button. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create button. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create button. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(text) ~= 'string' and type(text) ~= 'number' then
        error(('Couldn\'t create button. (expected text, got: %s)'):format(inspect(text)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create button. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']
    local hoverBgColor = options and options['hoverBgColor'] or _style['color']['hoverBackground']
    local textColor = options and options['textColor'] or _style['color']['text']
    local hoverTextColor = options and options['hoverTextColor'] or _style['color']['hoverText']
    local alignX = options and options['text-align-x'] or 'center'
    local alignY = options and options['text-align-y'] or 'center'
    local font = options and options['font'] or 'default-bold-small'

    local ignoreCollapse = options and options['ignoreCollapse'] or false

    local bg = CreateRectangle(x, y, w, h, relative, parent, {
        ['bgColor'] = bgColor,
    })

    if relative then
        x, y = guiGetPosition(bg, false)
        w, h = guiGetSize(bg, false)
    end

    local label = guiCreateLabel(5, 0, w - 10, h, text, false, bg)
    guiLabelSetColor(label, unpack(textColor))
    guiLabelSetHorizontalAlign(label, alignX, true)
    guiLabelSetVerticalAlign(label, alignY)
    guiSetFont(label, font)

    addEventHandler('onClientMouseEnter', label, function()
        if not ignoreCollapse then
            SetRectangleColor(bg, hoverBgColor)
            guiLabelSetColor(label, unpack(hoverTextColor))
            local x, y = guiGetPosition(bg, false)
            guiSetPosition(bg, x + 1, y + 1, false)
            guiSetSize(bg, w - 2, h - 2, false)
        end
    end, false)

    addEventHandler('onClientMouseLeave', label, function()
        if not ignoreCollapse then
            SetRectangleColor(bg, bgColor)
            guiLabelSetColor(label, unpack(textColor))
            local x, y = guiGetPosition(bg, false)
            guiSetPosition(bg, x - 1, y - 1, false)
            guiSetSize(bg, w, h, false)
        end
    end, false)

    addHandler(sourceResourceRoot, label)
    return label
end
