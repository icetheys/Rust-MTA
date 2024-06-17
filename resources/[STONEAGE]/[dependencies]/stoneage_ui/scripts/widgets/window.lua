addEvent('onCustomWindowClose', true)

function CreateWindow(x, y, w, h, text, parent, relative, closable, options)
    local bgColor = options and options['bgColor'] or _style['color']['background']
    local closeBgColor = options and options['closeBgColor'] or _style['color']['background']

    local bg = CreateRectangle(x, y, w, h, relative, nil, {
        bgColor = bgColor,
    })

    local text = CreateLabel(0, 0, w, 30, text, bg)

    if closable then
        local rec = CreateButton(w - 30, 0, 30, 30, 'X', false, bg, {
            bgColor = closeBgColor,
        })
        guiSetProperty(getElementParent(rec), 'AlwaysOnTop', 'True')

        addEventHandler('onClientGUIClick', rec, function()
            triggerEvent('onCustomWindowClose', bg)
        end, false)
    end
    return bg, text
end
