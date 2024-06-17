addEvent('onCheckBoxChangeState', true)
--[[
    Syntax:
        CreateCheckbox(x, y, w, text, relative, parent, options)
        options: {
            bgColor: {r,g,b,a},
            hoverBgColor: {r,g,b,a},
            textColor: {r,g,b},
            text-align-x: string,
            text-align-y: string,
        }
]]
function CreateCheckbox(x, y, w, relative, bool, parent, options)
    if not options then options = {} end
    options['ignoreCollapse'] = true

    local box = CreateTextWithBG(x, y, w, w, bool and '✔' or '', relative, parent, options)

    addEventHandler('onClientGUIClick', box, function()
        if guiGetText(source) == '✔' then
            guiSetText(source, '')
        else
            guiSetText(source, '✔')
        end
        triggerEvent('onCheckBoxChangeState', source, guiGetText(source) == '✔')
    end, false)

    addHandler(sourceResourceRoot, box)
    return box
end
