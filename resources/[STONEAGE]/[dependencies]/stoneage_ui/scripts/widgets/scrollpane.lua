local moving, offset, movingScrollPane, movingScroll, movingH

local hoverToScroll

--[[
    Syntax:
        CreateScrollPane(x, y, w, h, caption, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
            ignoreCollapse: bool,
        }
]]
function CreateScrollPane(x, y, w, h, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create combobox. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create combobox. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create combobox. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create combobox. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create combobox. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']
    local hoverBgColor = options and options['hoverBgColor'] or _style['color']['hoverBackground']

    local bg = CreateRectangle(x, y, w, h, relative, parent, {
        bgColor = {0, 0, 0, 0},
    })

    if relative then
        x, y = guiGetPosition(bg, false)
        w, h = guiGetSize(bg, false)
    end

    local scrollW = 10

    local scrollPaneBG = CreateRectangle(0, 0, w - scrollW, h, false, bg, {
        bgColor = {0, 0, 0, 0},
    })

    local scrollPane = guiCreateScrollPane(0, 0, w + scrollW * 2, h, false, scrollPaneBG)

    local scrollBG = CreateRectangle(w - scrollW, 0, scrollW, h, false, bg, {
        bgColor = bgColor,
    })

    local scroll = CreateRectangle(0, 0, scrollW, h * 0.2, false, scrollBG, {
        ['bgColor'] = hoverBgColor,
    })

    addEventHandler('onClientGUIMouseDown', scroll, function(_, _, my)
        local _, y = guiGetPosition(scroll, false)
        offset = my - y
        moving = true
        movingH = h
        movingScroll = scroll
        movingScrollPane = scrollPane
    end, false)

    addHandler(sourceResourceRoot, scrollPane)

    addEventHandler('onClientMouseEnter', scrollPane, function()
        hoverToScroll = scrollPane
    end)

    addEventHandler('onClientMouseLeave', scrollPane, function()
        hoverToScroll = nil
    end)

    ui[scrollPane] = {
        progress = 0,
        scroll = scroll,
    }

    return scrollPane
end

function scroll(key, state)
    if hoverToScroll and isElement(hoverToScroll) then
        local actual = ui[hoverToScroll].progress or 0

        local new = key == 'mouse_wheel_down' and actual + 5 or actual - 5

        if new < 0 then
            new = 0
        elseif new > 100 then
            new = 100
        end

        ui[hoverToScroll].progress = new

        guiScrollPaneSetVerticalScrollPosition(hoverToScroll, new)

        local _, mainH = guiGetSize(hoverToScroll, false)
        local scroll = ui[hoverToScroll].scroll
        if scroll then
            local _, h = guiGetSize(scroll, false)
            local newY = interpolateBetween(0, 0, 0, mainH - h, 0, 0, new * 0.01, 'Linear')
            guiSetPosition(scroll, 0, newY, false)
        end
    end
end
bindKey('mouse_wheel_up', 'down', scroll)
bindKey('mouse_wheel_down', 'down', scroll)

addEventHandler('onClientClick', root, function(_, state)
    if state == 'up' then
        moving = nil
        offset = nil
        movingH = nil
        movingScroll = nil
        movingScrollPane = nil
    end
end, false)

addEventHandler('onClientCursorMove', root, function(_, _, _, y)
    if moving then
        local NewY = y - offset;
        NewY = math.min(math.max(NewY, 0), movingH * 0.8);

        guiSetPosition(movingScroll, 0, NewY, false);

        guiScrollPaneSetVerticalScrollPosition(movingScrollPane, (NewY / (movingH * 0.8)) * 100);

        ui[movingScrollPane].progress = (NewY / (movingH * 0.8)) * 100
    end
end);
