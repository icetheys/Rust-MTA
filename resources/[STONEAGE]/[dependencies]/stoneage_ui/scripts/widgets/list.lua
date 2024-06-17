addEvent('ui:onSelectListItem', true)
--[[
    CreateList(x,y,w,h, relative, parent, options)
]]
function CreateList(x, y, w, h, relative, parent, options)
    if type(x) ~= 'number' then
        error(('Couldn\'t create gridlist. (expected x, got: %s)'):format(inspect(x)), 2)
    end
    if type(y) ~= 'number' then
        error(('Couldn\'t create gridlist. (expected y, got: %s)'):format(inspect(y)), 2)
    end
    if type(w) ~= 'number' then
        error(('Couldn\'t create gridlist. (expected w, got: %s)'):format(inspect(w)), 2)
    end
    if type(h) ~= 'number' then
        error(('Couldn\'t create gridlist. (expected h, got: %s)'):format(inspect(h)), 2)
    end
    if type(relative) ~= 'boolean' then
        error(('Couldn\'t create gridlist. (expected relative as bool, got: %s)'):format(inspect(relative)), 2)
    end

    local bgColor = options and options['bgColor'] or _style['color']['background']

    local mainBg = CreateScrollPane(x, y, w, h, relative, parent, {})
    local bg = CreateRectangle(0, 0, 1, 1, true, mainBg, {
        bgColor = bgColor,
    })

    ui[mainBg] = {
        selected = nil,
        items = {},
        bg = bg,
    }

    return mainBg
end

ResetListItems = function(list)
    if ui[list] then
        for k, v in ipairs(ui[list].items) do
            if isElement(v.bg) then
                destroyElement(v.bg)
            end
        end
        ui[list].items = {}
    end
end

function addListItem(list, text)
    local arr = ui[list]
    if arr then
        if arr.bg and isElement(arr.bg) then
            local mainW, mainH = guiGetSize(arr.bg, false)

            local scrollW = mainW * 0.05

            local h = sH * 0.025
            local itemBG = CreateRectangle(0, (h + 1) * #arr.items, mainW - scrollW, h, false, list)
            local itemText = createText(0, 0, 1, 1, text, true, itemBG)

            guiSetProperty(itemBG, 'AlwaysOnTop', 'True')

            table.insert(ui[list].items, {
                text = text,
                bg = itemBG,
            })

            addEventHandler('onClientGUIClick', itemText, function()
                if ui[list].selected then
                    SetRectangleColor(ui[list].selected.bg, _style['color']['background'])
                end

                SetRectangleColor(itemBG, _style['color']['hoverBackground'])

                ui[list].selected = {
                    text = text,
                    bg = itemBG,
                }

                triggerEvent('ui:onSelectListItem', list, text)
            end, false)

            if (h + 1) * #arr.items > mainH then
                guiSetSize(arr.bg, mainW, (h + 1) * #arr.items, false)
            end

        end
    end
end

function getSelectedListItem(list)
    if ui[list] then
        return ui[list].selected and ui[list].selected.text
    end
end

function setSelectedListItem(list, id)
    if ui[list] then

        if ui[list].selected then
            SetRectangleColor(ui[list].selected.bg, _style['color']['background'])
        end
        if id then
            ui[list].selected = {
                text = ui[list].items[id].text,
                bg = ui[list].items[id].bg,
            }
            SetRectangleColor(ui[list].items[id].bg, _style['color']['hoverBackground'])
        else
            ui[list].selected = nil
        end
    end
end
