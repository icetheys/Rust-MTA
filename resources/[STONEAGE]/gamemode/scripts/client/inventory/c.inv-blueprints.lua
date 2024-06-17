local selectedCategory = 1

function initBluePrints()
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local x = sW * 0.5 + (w * 0.5) + pixels(10)
    local y = sH * 0.17
    local h = sH * 0.2 + (inv.size.y * (inv.boxSize + inv.margin)) + pixels(25)

    local bg = UI:CreateRectangle(x, y, w, h, false, inv.gui.bg, {
        bgColor = {0, 0, 0, 0},
    })

    UI:createText(0, 0, w, pixels(30), 'BLUEPRINTS', false, bg, {
        font = cfont('franklin:medium'),
        ['text-align-x'] = 'right',
    })

    y = pixels(30)

    local categoriesBG = UI:CreateRectangle(0, y, w, sH * 0.06, false, bg, {
        bgColor = color('inv:boxColor'),
    })

    y = y + sH * 0.06 + inv.margin

    local width = sH * 0.05

    local categoryImages = {}
    for k, v in ipairs(blueprints) do
        local x = inv.margin * 2 + (k - 1) * (width + inv.margin * 2)
        local btn = UI:createImage(x, 4, width, width, (':gamemode/files/images/ui/%s.png'):format(v.category), false, categoriesBG, {
            bgColor = {210, 190, 175, 175},
            hoverBgColor = {210, 190, 175, 200},
        })

        addEventHandler('onClientGUIClick', btn, function()
            if selectedCategory ~= k then
                loadBluePrintCategory(k)
            end
        end, false)

        categoryImages[v.category] = btn
    end
    y = y + inv.margin

    local bgSelectedCategory = UI:CreateRectangle(0, y, w, sH * 0.025, false, bg, {
        bgColor = color('inv:boxColor'),
    })

    local lblSelectedCategory = UI:createText(0, 0, w, sH * 0.025, 'teste', false, bgSelectedCategory, {
        font = cfont('franklin'),
    })

    y = y + sH * 0.025 + inv.margin

    local containerToItems = UI:CreateScrollPane(0, y, w, h - y, false, bg, {
        bgColor = color('inv:boxColor:hover'),
        hoverBgColor = color('inv:boxColor:hover'),
    })

    UI:CreateRectangle(0, 0, w, h - y, false, containerToItems, {
        bgColor = color('inv:bg'),
        hoverBgColor = color('inv:boxColor:hover'),
    })

    guiSetVisible(bg, false)

    inv.gui.bluePrints = {
        bg = bg,
        selectedCategory = lblSelectedCategory,
        container = containerToItems,
        categoryImages = categoryImages,
    }

    loadBluePrintCategory(selectedCategory)
end

function loadBluePrintCategory(categoryID)
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local categorySelected = blueprints[categoryID].category

    local bg = inv.gui.bluePrints.container
    if selectedCategory then
        for k, v in ipairs(getElementChildren(bg)) do
            if isElement(v) then
                destroyElement(v)
            end
        end
    end

    for k, v in pairs(inv.gui.bluePrints.categoryImages) do
        local width = sH * 0.05
        local x = guiGetPosition(v, false)

        if k == categorySelected then
            guiSetSize(v, width, width, false)
            guiSetPosition(v, x, pixels(4), false)
        else

            local _, h = guiGetSize(getElementParent(v), false)
            guiSetPosition(v, x, h / 2 - (width / 1.5) / 2, false)
            guiSetSize(v, width / 1.5, width / 1.5, false)
        end
    end

    for k, v in ipairs(blueprints[categoryID].items) do
        local h = math.floor(inv.boxSize * 1.5)
        local y = math.floor((k - 1) * (h + inv.margin))

        local background = UI:CreateRectangle(0, y, w, h, false, bg, {
            bgColor = color('inv:boxColor'),
            hoverBgColor = color('inv:boxColor:hover'),
        })

        local icon
        if categorySelected == 'objects' then
            icon = getObjectIcon(v)
        else
            icon = (':gamemode/%s'):format(getItemIcon(v))
        end
        local icon = UI:createImage(5, 10, h - 10, h - 20, icon, false, background)

        local str
        local limit = getObjectLimit(v, localPlayer)
        if limit then
            str = ('%s (%i/%i)'):format(translate(v, 'name'), (getElementData(localPlayer, v) or 0), limit)
        else
            str = translate(v, 'name')
        end

        UI:createText(h, 0, w - h, h, str, false, background, {
            font = cfont('franklin'),
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
        })

        local custo = categorySelected == 'objects' and getObjectCustoString(v, 1, localPlayer) or getItemCustoString(v, localPlayer)
        UI:createText(h, h * 0.25, w - h - w * 0.1, h, custo, false, background, {
            font = cfont('franklin'),
            ['text-align-x'] = 'left',
            ['text-align-y'] = 'top',
        })

        local dummyFront = guiCreateLabel(0, 0, 1, 1, '', true, background)

        addEventHandler('onClientMouseEnter', dummyFront, function()
            local x, y = guiGetPosition(background, false)
            local w, h = guiGetSize(background, false)
            guiSetPosition(background, x + 1, y + 1, false)
            guiSetSize(background, w - 2, h - 2, false)
        end, false)

        addEventHandler('onClientMouseLeave', dummyFront, function()
            local x, y = guiGetPosition(background, false)
            local w, h = guiGetSize(background, false)
            guiSetPosition(background, x - 1, y - 1, false)
            guiSetSize(background, w + 2, h + 2, false)
        end, false)

        addEventHandler('onClientGUIClick', dummyFront, function(key)
            if (key ~= 'left') then
                return
            end
            
            startLoadingProcess(75, icon, function(itemName, categorySelected)
                local categorySelected = blueprints[selectedCategory].category
                triggerServerEvent('Craft:CraftItem', localPlayer, itemName, categorySelected)
            end, v, categorySelected)

        end, false)
    end

    guiSetText(inv.gui.bluePrints.selectedCategory, string.upper(translate(categorySelected)))
    selectedCategory = categoryID
end

function toggleBluePrints(state, inWorkbench)
    if state then
        if selectedCategory ~= 1 then
            loadBluePrintCategory(1)
        end
        local blockedThings = {'weapons', 'ammunition', 'explosives', 'misc2'}
        for k, v in ipairs(blockedThings) do
            if inWorkbench then
                guiSetEnabled(inv.gui.bluePrints.categoryImages[v], true)
                guiSetAlpha(inv.gui.bluePrints.categoryImages[v], 1)
            else
                guiSetEnabled(inv.gui.bluePrints.categoryImages[v], false)
                guiSetAlpha(inv.gui.bluePrints.categoryImages[v], 0.3)
            end
        end
    end
    guiSetVisible(inv.gui.bluePrints.bg, state)
end
