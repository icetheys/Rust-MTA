function initInvTopBar() --
    local w = inv.size.x * (inv.boxSize + inv.margin)
    local x = sW * 0.5 - (w / 2)
    local y = sH * 0.17
    local h = sH * 0.2

    local bg = UI:CreateRectangle(x, y, w, h, false, inv.gui.bg, {
        bgColor = color('inv:boxColor'),
    })

    local imgW = h * 0.6
    local imgBG = UI:CreateRectangle(w - imgW, 0, imgW, imgW, false, bg, {
        bgColor = color('inv:boxColor:hover'),
    })

    local img = guiCreateStaticImage(0, 0, imgW, imgW, 'files/images/logo.png', false, imgBG)

    local header = UI:createText(5, 5, w - imgW - 10, pixels(40), '', false, bg, {
        font = cfont('franklin:medium'),
        ['text-align-y'] = 'top',
    })

    local desc = UI:createText(5, pixels(40), w - imgW - 25, h, '', false, bg, {
        font = cfont('franklin'),
        ['text-align-x'] = 'left',
        ['text-align-y'] = 'top',
    })

    inv.gui.topBar = {
        bg = bg,
        image = img,
        header = header,
        desc = desc,
    }
    
    guiSetVisible(bg, false)

    setSelectedItem(false)
end

function setSelectedItem(state, options)
    if inv.gui.topBar.buttons then
        for k, v in ipairs(inv.gui.topBar.buttons) do
            local parent = getElementParent(v)
            if isElement(parent) then destroyElement(parent) end
        end
    end

    if state then
        guiSetText(inv.gui.topBar.header, translate(options.itemName, 'name'))
        guiSetText(inv.gui.topBar.desc, getItemDescription(options.itemName))
        guiStaticImageLoadImage(inv.gui.topBar.image, getItemIcon(options.itemName))

        if inv.selected then UI:setImageColor(inv.gui.slots[inv.selected.source][inv.selected.id].bg, color('inv:boxColor:hover')) end
        UI:setImageColor(inv.gui.slots[options.source][options.id].bg, color('inv:boxColor:selected'))
        inv.selected = options

        local disponibleButtons = getOptionsToUseItem(options.itemName, options.quantity)
        local w = inv.size.x * (inv.boxSize + inv.margin)
        local h = sH * 0.2

        local imgW = h * 0.6

        inv.gui.topBar.buttons = {}
        local btnW, btnH = imgW / 2, math.floor((h - imgW - inv.margin * 2) / #disponibleButtons)
        for k, v in ipairs(disponibleButtons) do
            local btn = UI:CreateButton(w - (imgW - btnW / 2), (k - 1) * (btnH + inv.margin) + imgW + inv.margin, btnW, btnH, translate(v), false,
                                        inv.gui.topBar.bg, {
                bgColor = color('inv:boxColor'),
                hoverBgColor = color('inv:boxColor:hover'),
                font = cfont('franklin'),
            })
            inv.gui.topBar.buttons[k] = btn

            addEventHandler('onClientGUIClick', btn, function()
                onClickRightOptions(k) 
            end, false)
        end

        local w = inv.size.x * (inv.boxSize + inv.margin)
        local x = sW * 0.5 - (w / 2)
        local y = sH * 0.17
        local h = sH * 0.2

        guiSetSize(inv.gui.topBar.bg, w, h - inv.margin*2, false)
        guiSetPosition(inv.gui.topBar.bg, x, y, false)

    else

        local w = inv.size.x * (inv.boxSize + inv.margin)
        local x = sW * 0.5 - (w / 2)
        local y = sH * 0.17
        local h = sH * 0.2
        local imgW = h * 0.6

        guiSetSize(inv.gui.topBar.bg, w, imgW, false)
        guiSetPosition(inv.gui.topBar.bg, x, y + (h - imgW) - inv.margin, false)

        guiSetText(inv.gui.topBar.header, 'Your server name')
        guiSetText(inv.gui.topBar.desc, translate('Selecione um item para ver as informações sobre ele.'))
        guiStaticImageLoadImage(inv.gui.topBar.image, 'files/images/logo.png')

        inv.gui.topBar.buttons = nil

        if inv.selected then UI:setImageColor(inv.gui.slots[inv.selected.source][inv.selected.id].bg, color('inv:boxColor:hover')) end

        inv.selected = nil
    end
end

local timer
function setInvMessage(str)
    if timer and isTimer(timer) then killTimer(timer) end
    if not inv.gui.info then
        local w = inv.size.x * (inv.boxSize + inv.margin)
        local x = sW * 0.5 - (w / 2)
        local y = sH * 0.17

        inv.gui.info = UI:createText(x, 0, w, y, str, false, inv.gui.bg, {
            font = cfont('franklin'),
            ['text-align-x'] = 'center',
            ['text-align-y'] = 'bottom',
        })
    else
        if isElement(inv.gui.info) then guiSetText(inv.gui.info, str) end
    end
    timer = setTimer(function()
        if inv.gui.info and isElement(inv.gui.info) then destroyElement(inv.gui.info) end
        inv.gui.info = nil
        timer = nil
    end, 5000, 1)
end

