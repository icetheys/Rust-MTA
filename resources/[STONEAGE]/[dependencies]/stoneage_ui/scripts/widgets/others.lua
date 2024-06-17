--[[
    Syntax:
        CreateTextWithBG(x, y, w, h, text, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
        }
]]
function CreateTextWithBG(x, y, w, h, text, relative, parent, options)
    if not options then
        options = {}
    end
    options['ignoreCollapse'] = true
    return CreateButton(x, y, w, h, text, relative, parent, options)
end

--[[
    Syntax:
        CreateImageWithBG(x, y, w, h, filepath, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            imgColor: {r,g,b,a},
        }
]]
function CreateImageWithBG(x, y, w, h, filePath, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create imageWithBG. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    if not filePath or not fileExists(filePath) then
        error(('Couldn\'t create imageWithBG. (filepath doesnt exists, got: %s)'):format(filePath))
    end

    local imgColor = options and options['imgColor']

    local bg = CreateRectangle(x, y, w, h, relative, parent, options)
    local w, h = guiGetSize(bg, false)
    local icon = guiCreateStaticImage(1, 1, w - 2, h - 2, filePath, false, bg)

    if imgColor then
        SetRectangleColor(icon, imgColor)
    end

    return icon
end

--[[
    Syntax:
        createText(x, y, w, h, str, relative, parent, options)
        options: {
            font: font,
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
        }
]]
function createText(x, y, w, h, text, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create imageWithBG. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create imageWithBG. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end
    if type(text) ~= 'string' and type(text) ~= 'number' then
        error(('Couldn\'t create button. (expected text, got: %s)'):format(inspect(text)), 2)
    end

    local textColor = options and options['textColor'] or _style['color']['text']
    local alignX = options and options['text-align-x'] or 'center'
    local alignY = options and options['text-align-y'] or 'center'
    local font = options and options['font'] or 'default-bold-small'

    local lbl = guiCreateLabel(x, y, w, h, text, relative, parent)

    guiLabelSetVerticalAlign(lbl, alignY)
    guiLabelSetHorizontalAlign(lbl, alignX, true)
    guiSetFont(lbl, font)
    guiLabelSetColor(lbl, unpack(textColor))
    guiSetAlpha(lbl, (textColor[4] or 255) / 255)

    addHandler(sourceResourceRoot, lbl)
    return lbl
end

--[[
    Syntax:
        createImage(x, y, w, h, str, relative, path, parent, options)
        options: {
            font: font,
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
        }
]]
function createImage(x, y, w, h, path, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create image. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create image. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create image. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create image. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create image. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end
    if not path or not fileExists(path) then
        error(('Couldn\'t create image. (path doesnt exists, got: %s)'):format(path))
    end

    local color = options and options['bgColor'] or {255, 255, 255, 255}
    local hoverColor = options and options['hoverBgColor'] or {255, 255, 255, 200}

    local img = guiCreateStaticImage(x, y, w, h, path, relative, parent)
    setImageColor(img, color)

    addEventHandler('onClientMouseEnter', img, function()
        if (getElementParent(source) == img) or (source == img) then
            setImageColor(img, hoverColor)
        end
    end, true)

    addEventHandler('onClientMouseLeave', img, function()
        if (getElementParent(source) == img) or (source == img) then
            setImageColor(img, color)
        end
    end, true)

    addHandler(sourceResourceRoot, img)
    return img
end

function setImageColor(img, color)
    if type(color) ~= 'table' then
        error(('Couldn\'t change image color. (expected color as table, got: %s)'):format(inspect(color)), 2)
    end
    if isElement(img) then
        if color then
            color = color or {255, 255, 255, 255}
            color = RGBToAARRGGBB(color[1], color[2], color[3], color[4] or 255)
            guiSetProperty(img, 'ImageColours', 'tl:' .. color .. ' tr:' .. color .. ' bl:' .. color .. ' br:' .. color)
        end
    end
end
