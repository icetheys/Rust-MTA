addEvent('onComboboxSelectItem', true)
--[[
    Syntax:
        CreateComboBox(x, y, w, h, caption, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
            headerColor: {r,g,b,a}            
        }
]]
function CreateComboBox(x, y, w, h, caption, relative, parent, options)
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
    if type(caption) ~= 'string' then
        error(('Couldn\'t create combobox. (expected caption, got: %s)'):format(inspect(caption)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create combobox. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']
    local hoverBgColor = options and options['hoverBgColor'] or _style['color']['hoverBackground']
    local textColor = options and options['textColor'] or _style['color']['text']
    local hoverTextColor = options and options['hoverTextColor'] or _style['color']['hoverText']
    local headerColor = options and options['headerColor'] or _style['color']['headers']
    local alignX = options and options['text-align-x'] or 'center'
    local alignY = options and options['text-align-y'] or 'center'

    local selectedH = relative and 0.0275 or 20

    local bg = CreateRectangle(x, y, w, selectedH, relative, parent, {
        ['bgColor'] = headerColor,
    })

    CreateRectangle(0, -2, w, 2, false, bg, {
        ['bgColor'] = textColor
    })

    local mainH = h

    x, y = guiGetPosition(bg, false)
    w, h = guiGetSize(bg, false)

    local selected = guiCreateLabel(0, 0, w - 20, h, caption, false, bg)
    guiLabelSetColor(selected, unpack(textColor))
    guiLabelSetHorizontalAlign(selected, alignX, true)
    guiLabelSetVerticalAlign(selected, alignY)

    local seta = CreateTextWithBG(w - 20, 1, 20, 20, '▼', false, bg, {
        ['bgColor'] = bgColor,
        ['hoverBgColor'] = hoverBgColor,
        ['textColor'] = textColor,
        ['hoverTextColor'] = hoverTextColor,
        ['text-align-x'] = alignX,
        ['text-align-y'] = alignY,
    })

    local scrollPane = CreateScrollPane(0, 20, w, mainH - 20, false, bg, {});

    ui[scrollPane] = {
        items = {},
        state = 'hidden',
        header = selected,
        seta = seta,
        bg = bg,
        selected = {false, false},
    }

    addEventHandler('onClientGUIClick', seta, function()
        if ui[scrollPane].state == 'hidden' then
            guiSetSize(bg, w, mainH, false)
            guiSetText(seta, '▲')
            ui[scrollPane].state = 'visible'
        else
            guiSetSize(bg, w, 20, false)
            guiSetText(seta, '▼')
            ui[scrollPane].state = 'hidden'
        end
    end, false)

    addEventHandler('onClientGUIClick', selected, function()
        if ui[scrollPane].state == 'hidden' then
            guiSetSize(bg, w, mainH, false)
            guiSetText(seta, '▲')
            ui[scrollPane].state = 'visible'
        else
            guiSetSize(bg, w, 20, false)
            guiSetText(seta, '▼')
            ui[scrollPane].state = 'hidden'
        end
    end, false)

    addHandler(sourceResourceRoot, scrollPane)
    return scrollPane
end

getComboBoxSelectedItem = function(elem)
    if ui[elem] then
        return unpack(ui[elem].selected)
    end
    return false
end

function addComboBoxItem(elem, str)
    if isElement(elem) then
        if ui[elem] then
            local w = guiGetSize(elem, false)
            w = w -20
            local text = CreateTextWithBG(0, #ui[elem].items * 25, w, 25, str, false, elem, {})

            addEventHandler('onClientGUIClick', text, function()
                ui[elem].selected = {false, false}
                for k, v in ipairs(ui[elem].items) do
                    if v.source == source then
                        ui[elem].selected = {k, v.name}
                    end
                end
                local id, text = unpack(ui[elem].selected)

                guiSetText(ui[elem].header, text)
                guiSetSize(ui[elem].bg, w, 20, false)
                guiSetText(ui[elem].seta, '▼')
                ui[elem].state = 'hidden'

                triggerEvent('onComboboxSelectItem', elem, id, text)
            end, false)

            table.insert(ui[elem].items, {
                name = str,
                source = text,
            })

        end
    end
end
