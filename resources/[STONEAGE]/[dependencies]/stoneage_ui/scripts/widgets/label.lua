CreateLabel = function(x, y, w, h, text, parent, alignX, alignY)
    local Label = guiCreateLabel(x, y, w, h, text, false, parent)
    guiLabelSetHorizontalAlign(Label, alignX or 'center', true)
    guiLabelSetVerticalAlign(Label, alignY or 'center')
    guiSetFont(Label, 'default-bold-small')
    guiLabelSetColor(Label, unpack(_style['color']['text']))

    return Label
end
