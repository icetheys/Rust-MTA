ui = {}
sW, sH = 800, 600
sW, sH = guiGetScreenSize()

function addHandler(res, parent)
    if not res then
        res = resourceRoot
    end
    if not ui[res] then
        ui[res] = {}
    end
    if parent then
        table.insert(ui[res], parent)
    end
end

addEventHandler('onClientResourceStop', root, function()
    if ui[source] then
        for k, v in pairs(ui[source]) do
            if isElement(v) then
                destroyElement(v)
            end
        end
    end
    ui[source] = nil
end)

addEventHandler('onClientElementDestroy', resourceRoot, function()
    if ui[source] then
        ui[source] = nil
    end
end)

addEventHandler('onClientGUIClick', root, function()
    local text = guiGetText(source)
    if (text:len() > 0) and getKeyState('lctrl') then
        outputConsole(text)
    end
end)
