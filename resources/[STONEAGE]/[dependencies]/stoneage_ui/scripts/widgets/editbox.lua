--[[
    Syntax:
        CreateEditBox(x, y, w, h, placeholder, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            masked: bool,
        }
]]
function CreateEditBox(x, y, w, h, placeholder, relative, parent, options)
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
    if type(placeholder) ~= 'string' then
        error(('Couldn\'t create button. (expected placeholder, got: %s)'):format(inspect(placeholder)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create button. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']
    local hoverBgColor = options and options['hoverBgColor'] or _style['color']['hoverBackground']
    local textColor = options and options['textColor'] or _style['color']['text']
    local hoverTextColor = options and options['hoverTextColor'] or _style['color']['hoverText']
    local masked = options and options['masked'] or false

    local bg = CreateRectangle(x, y, w, h, relative, parent, {
        ['bgColor'] = bgColor
    })

    if relative then
        x, y = guiGetPosition(bg, false)
        w, h = guiGetSize(bg, false)
    end

    local line = CreateRectangle(0, -2, w, 2, false, bg, {
        ['bgColor'] = textColor
    })

    local label = guiCreateLabel(8, 0, w - 20, h, '', false, bg)
    guiLabelSetVerticalAlign(label, 'center')
    guiLabelSetColor(label, unpack(textColor))
    guiSetFont(label, 'default-normal')

    local edit = guiCreateEdit(0, 0, w, h, '', false, bg)

    if masked then
        guiEditSetMasked(edit, true)
    end
    guiSetAlpha(edit, 0.0)

    addEventHandler('onClientMouseEnter', edit, function()
        SetRectangleColor(bg, hoverBgColor);
        SetRectangleColor(line, hoverTextColor);
        guiLabelSetColor(label, unpack(hoverTextColor));
    end, false);

    addEventHandler('onClientMouseLeave', edit, function()
        SetRectangleColor(bg, bgColor);
        SetRectangleColor(line, textColor);
        guiLabelSetColor(label, unpack(textColor));
    end, false);

    addEventHandler('onClientGUIChanged', edit, function()
        local text = guiGetText(source)
        if guiEditIsMasked(source) then
            text = string.gsub(text, '.', '*')
        end

        if dxGetTextWidth(text, 1, 'default-bold-small') > (w - 6) then
            guiLabelSetHorizontalAlign(label, 'right')
        else
            guiLabelSetHorizontalAlign(label, 'left')
        end

        if text == '' then
            guiSetText(label, masked and string.gsub(placeholder, '.', '*') or placeholder)
            guiSetAlpha(label, 0.4)
        else
            guiSetText(label, text)
            guiSetAlpha(label, 1)
        end
    end)

    guiSetText(label, placeholder)

    addHandler(sourceResourceRoot, edit)
    return edit
end
