--[[
    Syntax:
        CreateProgressBar(x, y, w, h, text, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            progressColor: {r,g,b,a},
            hoverProgressColor: {r,g,b,a},
            text-align-x: string,
            text-align-y: string,
            progressAlign: string,
        }
]]
function CreateProgressBar(x, y, w, h, percent, relative, parent, options)
    if type(x) ~= 'number' then error(('Couldn\'t create progressBar. (expected x, got: %s)'):format(inspect(x)), 2) end
    if type(y) ~= 'number' then error(('Couldn\'t create progressBar. (expected y, got: %s)'):format(inspect(y)), 2) end
    if type(w) ~= 'number' then error(('Couldn\'t create progressBar. (expected w, got: %s)'):format(inspect(w)), 2) end
    if type(h) ~= 'number' then error(('Couldn\'t create progressBar. (expected h, got: %s)'):format(inspect(h)), 2) end
    if type(percent) ~= 'number' then error(('Couldn\'t create progressBar. (expected percent, got: %s)'):format(inspect(percent)), 2) end
    if type(relative) ~= 'boolean' then error(('Couldn\'t create progressBar. (expected relative as bool, got: %s)'):format(inspect(relative)), 2) end

    if percent < 0 then
        percent = 0
    elseif percent > 100 then
        percent = 100
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']
    local hoverBgColor = options and options['hoverBgColor'] or _style['color']['hoverBackground']
    local progressColor = options and options['progressColor'] or _style['color']['progress']
    local hoverProgressColor = options and options['hoverProgressColor'] or _style['color']['hoverProgress']
    local progressAlign = options and options['progressAlign'] or 'horizontal'

    local bg = CreateRectangle(x, y, w, h, relative, parent, {
        ['bgColor'] = bgColor,
    })

    local progress

    if progressAlign == 'horizontal' then
        local percentW = interpolateBetween(0, 0, 0, w - 4, 0, 0, percent * 0.01, 'Linear')
        progress = CreateRectangle(2, 2, percentW, h - 4, false, bg, {
            ['bgColor'] = progressColor,
        })
    else
        local percentH = interpolateBetween(0, 0, 0, h - 4, 0, 0, percent * 0.01, 'Linear')
        progress = CreateRectangle(2, h - 2 - percentH, w - 4, percentH, false, bg, {
            ['bgColor'] = progressColor,
        })
    end

    if relative then
        x, y = guiGetPosition(bg, false)
        w, h = guiGetSize(bg, false)
    end

    addEventHandler('onClientMouseEnter', bg, function()
        SetRectangleColor(bg, hoverBgColor)
        SetRectangleColor(progress, hoverProgressColor)
    end)

    addEventHandler('onClientMouseLeave', bg, function()
        SetRectangleColor(bg, bgColor)
        SetRectangleColor(progress, progressColor)
    end)

    ui[bg] = {
        progress = progress,
        align = progressAlign,
        percent = percent,
    }

    addHandler(sourceResourceRoot, label)
    return bg
end

function setProgress(elem, percent)
    if isElement(elem) and ui[elem] then
        if type(percent) ~= 'number' then error(('Couldn\'t update progressBar. (expected percent, got: %s)'):format(inspect(percent)), 2) end
        if percent < 0 then
            percent = 0
        elseif percent > 100 then
            percent = 100
        end

        local progress = ui[elem].progress
        local w, h = guiGetSize(elem, false)

        if ui[elem].align == 'horizontal' then

            local percentW = interpolateBetween(0, 0, 0, w - 2, 0, 0, percent * 0.01, 'Linear')
            guiSetSize(progress, percentW, h - 2, false)
        else
            local percentH = interpolateBetween(0, 0, 0, h - 4, 0, 0, percent * 0.01, 'Linear')
            guiSetSize(progress, w - 4, percentH, false)
            guiSetPosition(progress, 2, h - 2 - percentH, false)
        end
    end
end

