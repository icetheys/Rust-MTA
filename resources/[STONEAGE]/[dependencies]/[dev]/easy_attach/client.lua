local edit = {}
local button = {}
local toDo = {}
local window, object

local boneAttach = exports['stoneage_bone_attach']

function toggleAttachWindow(state)
    if isElement(window) then
        destroyElement(window)
    end
    if isElement(object) then
        destroyElement(object)
    end
    
    if state then
        local w, h = 0.15, 0.32
        window = guiCreateWindow(1 - w * 1.25, 0.5 - h / 2, w, h, "EASY ATTACH V0.1 BY IDANNZ", true)
        guiWindowSetSizable(window, false)
        
        customLabel(0.04, 0.07, 0.30, 0.06, "MODEL", true, window, 'center', 'center')
        edit['model'] = guiCreateEdit(0.04, 0.13, 0.30, 0.07, "2703", true, window)
        
        customLabel(0.34, 0.07, 0.30, 0.06, "BONE", true, window, 'center', 'center')
        edit['bone'] = guiCreateEdit(0.34, 0.13, 0.30, 0.07, "12", true, window)
        
        customLabel(0.64, 0.07, 0.30, 0.06, "SCALE", true, window, 'center', 'center')
        edit['scale'] = guiCreateEdit(0.64, 0.13, 0.30, 0.07, "1", true, window)
        
        customLabel(0.04, 0.23, 0.30, 0.06, "X", true, window, 'center', 'center')
        edit['x'] = guiCreateEdit(0.04, 0.28, 0.30, 0.07, "0", true, window)
        button['x+'] = guiCreateButton(0.04, 0.35, 0.15, 0.06, "+", true, window)
        button['x-'] = guiCreateButton(0.19, 0.35, 0.15, 0.06, "-", true, window)
        toDo[button['x+']] = 'x'
        toDo[button['x-']] = 'x'
        
        customLabel(0.34, 0.23, 0.30, 0.06, "Y", true, window, 'center', 'center')
        edit['y'] = guiCreateEdit(0.34, 0.28, 0.30, 0.07, "0", true, window)
        button['y+'] = guiCreateButton(0.34, 0.35, 0.15, 0.06, "+", true, window)
        button['y-'] = guiCreateButton(0.49, 0.35, 0.15, 0.06, "-", true, window)
        toDo[button['y+']] = 'y'
        toDo[button['y-']] = 'y'
        
        customLabel(0.64, 0.23, 0.30, 0.06, "Z", true, window, 'center', 'center')
        edit['z'] = guiCreateEdit(0.64, 0.28, 0.30, 0.07, "0", true, window)
        button['z+'] = guiCreateButton(0.64, 0.35, 0.15, 0.06, "+", true, window)
        button['z-'] = guiCreateButton(0.79, 0.35, 0.15, 0.06, "-", true, window)
        toDo[button['z+']] = 'z'
        toDo[button['z-']] = 'z'
        
        customLabel(0.04, 0.45, 0.30, 0.06, "RX", true, window, 'center', 'center')
        edit['rx'] = guiCreateEdit(0.04, 0.51, 0.30, 0.07, "0", true, window)
        button['rx+'] = guiCreateButton(0.04, 0.58, 0.15, 0.06, "+", true, window)
        button['rx-'] = guiCreateButton(0.19, 0.58, 0.15, 0.06, "-", true, window)
        toDo[button['rx+']] = 'rx'
        toDo[button['rx-']] = 'rx'
        
        customLabel(0.34, 0.45, 0.30, 0.06, "RY", true, window, 'center', 'center')
        edit['ry'] = guiCreateEdit(0.34, 0.51, 0.30, 0.07, "0", true, window)
        button['ry+'] = guiCreateButton(0.34, 0.58, 0.15, 0.06, "+", true, window)
        button['ry-'] = guiCreateButton(0.49, 0.58, 0.16, 0.06, "-", true, window)
        toDo[button['ry+']] = 'ry'
        toDo[button['ry-']] = 'ry'
        
        customLabel(0.65, 0.45, 0.30, 0.06, "RZ", true, window, 'center', 'center')
        edit['rz'] = guiCreateEdit(0.64, 0.51, 0.31, 0.07, "0", true, window)
        button['rz+'] = guiCreateButton(0.64, 0.58, 0.15, 0.06, "+", true, window)
        button['rz-'] = guiCreateButton(0.79, 0.58, 0.16, 0.06, "-", true, window)
        toDo[button['rz+']] = 'rz'
        toDo[button['rz-']] = 'rz'
        
        customLabel(0.04, 0.67, 0.91, 0.06, "OUTPUT", true, window, 'center', 'center')
        edit['output'] = guiCreateEdit(0.03, 0.73, 0.92, 0.07, "", true, window)
        guiEditSetReadOnly(edit['output'], true)
        
        customLabel(0.04, 0.83, 0.45, 0.06, "TOLERANCE POS", true, window, 'center', 'center')
        edit['tolerancePos'] = guiCreateEdit(0.03, 0.89, 0.45, 0.08, "0.01", true, window)
        
        customLabel(0.50, 0.83, 0.45, 0.06, "TOLERANCE ROT", true, window, 'center', 'center')
        edit['toleranceRot'] = guiCreateEdit(0.50, 0.89, 0.45, 0.08, "10", true, window)
        
        
        updateOutput()
    end
    
    showCursor(state)
end

bindKey('mouse2', 'down', function(key, state)
    local state = not isCursorShowing()
    if state and not isElement(window) then
        return
    end
    showCursor(state)
end)

function onClick(btn)
    if btn == 'left' then
        changeByClick(source)
    end
end
addEventHandler('onClientGUIClick', resourceRoot, onClick)

function changeByClick(elem)
    if toDo[elem] then
        local tolerance
        
        local isRot = toDo[elem] == 'rx' or toDo[elem] == 'ry' or toDo[elem] == 'rz'
        
        if not isRot then
            tolerance = guiGetText(edit['tolerancePos'])
        else
            tolerance = guiGetText(edit['toleranceRot'])
        end
        
        local action = guiGetText(elem)
        local actual = tonumber(guiGetText(edit[toDo[elem]]))
        local new
        if action == '+' then
            new = actual + tolerance
        elseif action == '-' then
            new = actual - tolerance
        end
        
        if isRot and new < 0 then
            new = 0
        elseif isRot and new > 360 then
            new = 360
        end
        
        guiSetText(edit[toDo[elem]], new)
    end
end


function checkValidNumber()
    if source == edit['output'] then return end
    local str = guiGetText(source)
    if not tonumber(str) then
        local len = utf8.len(str)
        if len == 1 then
            guiSetText(source, '0')
        else
            guiSetText(source, utf8.sub(str, 1, len - 1))
        end
    end
    if guiGetText(source) == '' then
        guiSetText(source, '0')
        guiEditSetCaretIndex(source, 1)
    end
    updateOutput()
end
addEventHandler('onClientGUIChanged', resourceRoot, checkValidNumber)


function updateOutput()
    local bone = tonumber(guiGetText(edit['bone']))
    local x = tonumber(guiGetText(edit['x']))
    local y = tonumber(guiGetText(edit['y']))
    local z = tonumber(guiGetText(edit['z']))
    local rx = tonumber(guiGetText(edit['rx']))
    local ry = tonumber(guiGetText(edit['ry']))
    local rz = tonumber(guiGetText(edit['rz']))
    local scale = tonumber(guiGetText(edit['scale']))
    local model = tonumber(guiGetText(edit['model']))
    
    local str = string.format('%s, %s, %s, %s, %s, %s, %s', bone, x, y, z, rx, ry, rz)
    guiSetText(edit['output'], str)
    if isElement(object) then
        destroyElement(object)
    end
    
    local px, py, pz = getElementPosition(localPlayer)
    object = createObject(model, px, py, pz)
    
    setObjectScale(object, scale)
    
    boneAttach:attachElementToBone(object, localPlayer, bone, x, y, z, rx, ry, rz)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    toggleAttachWindow(true)
end)

bindKey('f4', 'down', function(key, state)
    toggleAttachWindow(not isElement(window))
end)

function customLabel(x, y, w, h, text, relative, parent, horizontal, vertical)
    local lbl = guiCreateLabel(x, y, w, h, text, relative, parent)
    if horizontal then
        guiLabelSetHorizontalAlign(lbl, horizontal)
    end
    if vertical then
        guiLabelSetVerticalAlign(lbl, vertical)
    end
    return lbl
end