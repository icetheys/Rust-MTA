OutputQuantity = function()
    local arr = {}
    for _, res in pairs(getResources()) do
        if (getResourceState(res) == 'running') then
            local obQuantity = #getElementsByType('object', getResourceRootElement(res))
            if obQuantity > 0 then
                table.insert(arr, {
                    name = getResourceName(res),
                    quantity = obQuantity
                })
            end
        end
    end
    table.sort(arr, function(a, b)
        return a.quantity < b.quantity
    end)

    iprint(arr)
end

OutputQuantity()
