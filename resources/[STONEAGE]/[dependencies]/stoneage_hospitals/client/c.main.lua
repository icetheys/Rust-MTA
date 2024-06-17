addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if getElementModel(source) == 1558 then
        setObjectBreakable(source, false)
    end
end)
