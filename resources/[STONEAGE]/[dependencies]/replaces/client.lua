Replaces = {}

local cache = {['txd'] = {}, ['dff'] = {}, ['col'] = {}}

local funcMethods = {
    ['txd'] = function(content, modelID, fileName)
        local txd = content and cache['txd'][fileName] or engineLoadTXD(content)
        if (not txd) then
            cache['txd'][fileName] = false
            return false
        end
        cache['txd'][fileName] = txd
        return engineImportTXD(txd, modelID)
    end,
    
    ['dff'] = function(content, modelID, fileName)
        local dff = content and cache['dff'][fileName] or engineLoadDFF(content)
        if (not dff) then
            cache['dff'][fileName] = false
            return false, print(('Falha ao carregar dff: %s no modelo: %i'):format(fileName, modelID))
        end
        cache['dff'][fileName] = dff
        return engineReplaceModel(dff, modelID)
    end,
    ['col'] = function(content, modelID, fileName)
        local col = content and cache['col'][fileName] or engineLoadCOL(content)
        if (not col) then
            cache['col'][fileName] = false
            return false, print(('Falha ao carregar col: %s no modelo: %i'):format(fileName, modelID))
        end
        cache['col'][fileName] = col
        return engineReplaceCOL(col, modelID)
    end
}

addEventHandler('onClientResourceStart', resourceRoot, function()
    local total = #Replaces
    local start = getTickCount()
    
    Async:setPriority('high')
    
    exports['stoneage_loadscreen']:setHeader('Unpacking files')
    
    Async:foreach(Replaces, function(v, k)
            exports['stoneage_loadscreen']:setInfo(('%i/%i (%i%%)'):format(k, total, (k * 100 / total)))
            if v.custom then
                for method, fileName in pairs(v.custom) do
                    if fileName and funcMethods[method] then
                        local content = decrypt(('files/%s.%s_encrypted'):format(fileName, method))
                        if (not funcMethods[method](content, v.model, fileName)) then
                            return triggerServerEvent('rust:customKick', localPlayer, ('Error loading model (%s - %s)'):format(method, fileName, v.model))
                        end
                    end
                end
            end
            for d, method in ipairs({'txd', 'dff', 'col'}) do
                if (not v.custom) or (v.custom[method] == nil) then
                    local content = decrypt(('files/%s.%s_encrypted'):format(v.file, method))
                    if (not funcMethods[method](content, v.model, v.file)) then
                        return triggerServerEvent('rust:customKick', localPlayer, ('Error loading model (%s - %s)'):format(method, v.file, v.model))
                    end
                end
            end
            if (v.model < 19999) then
                engineSetModelLODDistance(v.model, 400)
            end
    end, function()
        if (not getElementData(localPlayer, 'account')) then
            local secondsToWait = 10
            local whitelistedSerials = {
                ['DEEAE6EFF7B276C1BD2EC37B911587B2'] = true,
                ['1A37A6CB366ABBEDE08F6FE646A6FDB2'] = true,
            }
            if whitelistedSerials[getPlayerSerial()] then
                secondsToWait = 3
            end
            exports['stoneage_loadscreen']:setHeader('Pronto!')
            exports['stoneage_loadscreen']:setInfo('Entrando no jogo em ' .. secondsToWait)
            setTimer(function()
                local _, left = getTimerDetails(sourceTimer)
                if (left == 1) then
                    exports['stoneage_loadscreen']:toggleLoadScreen(false)
                    -- exports['gamemode']:toggleLogin(true)
                    triggerServerEvent('requestStaffPermissions', localPlayer)
                else
                    exports['stoneage_loadscreen']:setInfo('Entrando no jogo em ' .. left - 1)
                end
            end, 1000, secondsToWait)
        end
        print(('Replaced in %ims'):format(getTickCount() - start))
        Replaces = nil
        cache = nil
    end)
end)

local replaced = {}
assignReplace = function(model, arr)
    if replaced[model] then
        print('ID DUPLICADO: ', model)
    end
    replaced[model] = true
    arr.model = model
    table.insert(Replaces, arr)
-- Replaces[model] = arr
end
