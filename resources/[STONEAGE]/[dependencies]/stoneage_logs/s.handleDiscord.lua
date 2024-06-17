discordAvailableLogs = {
    ['joinquit'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['death'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['chat-local'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['chat-global'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['craft-object'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['craft-item'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['object-damage'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['object-destroy'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['vips'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['staff-actions'] = {
        webHookURL = 'YOURWEBHOOK',
    },
    ['suspeitas'] = {
        webHookURL = 'YOURWEBHOOK',
    },
}

addEventHandler('onPlayerJoin', root, function()
    local embeds = {{
        ['description'] = (':point_right: O jogador **%s** acabou de **ENTRAR** no servidor.'):format(getPlayerName(source)),
        ['color'] = 0xFFFF00,
        ['fields'] = {{
            name = ('Dados de %s:'):format(getPlayerName(source)),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
        }},
    }}
    sendDiscordLog('joinquit', embeds)
end)

addEventHandler('onPlayerQuit', root, function()
    local embeds = {{
        ['description'] = (':point_left: O jogador **%s** acabou de **SAIR** do servidor.'):format(getPlayerName(source)),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = ('Dados de %s:'):format(getPlayerName(source)),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
        }},
    }}
    sendDiscordLog('joinquit', embeds)
end)

-- local ignoredCommands = {
--     ['say'] = true,
--     ['admin'] = true,
--     ['voiceptt'] = true,
--     ['restart'] = true,
--     ['clearchat'] = true,
--     ['clear'] = true,
--     ['stgadmin'] = true,
--     ['stgfly'] = true,
--     ['debugscript'] = true,
-- }

-- addEventHandler('onPlayerCommand', root, function(cmd)
--     if not ignoredCommands[cmd] then
--         local embeds = {{
--             ['description'] = (':keyboard: O jogador **%s** acabou de digitar o comando **%s**.'):format(getPlayerName(source), cmd:upper()),
--             ['color'] = 0xFFFF00,
--             ['fields'] = {{
--                 name = ('Dados de %s:'):format(getPlayerName(source)),
--                 value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
--             }},
--         }}
--         sendDiscordLog('commands', embeds)
--     end
-- end)

addEvent('player:onDie', true)
addEventHandler('player:onDie', root, function(arr)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local reason = ''
    for k, v in pairs(arr) do
        reason = reason .. ('%s: %s\n'):format(tostring(k), tostring(v))
    end
    local x, y, z = getElementPosition(source)

    local embeds = {{
        ['description'] = (':headstone: O jogador **%s** foi morto.'):format(getPlayerName(source)),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = 'Dados da morte:',
            value = ('```%s```'):format(reason),
        }, {
            name = ('Dados de %s:'):format(getPlayerName(source)),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
        }, {
            name = ('Localização de %s:'):format(getPlayerName(source)),
            value =  ('```%s (%s) - [%.3f, %.3f, %.3f]```'):format(getZoneName(x, y, z), getZoneName(x, y, z, true), x, y, z),
        }},
    }}
    sendDiscordLog('death', embeds)
end)

local chatMessages = {}
onSendChatMessage = function(player, chatType, message)
    if (not chatMessages[chatType]) then
        chatMessages[chatType] = {}
    end
    table.insert(chatMessages[chatType], message)
    if (#chatMessages[chatType] >= 20) then
        local embeds = {{
            ['color'] = 0xFFFF00,
            ['description'] = ('```%s```'):format(table.concat(chatMessages[chatType], '\n')),
        }}
        sendDiscordLog(chatType, embeds)
        chatMessages[chatType] = {}
    end 
end

addEvent('onPlayerCraftObject', true)
addEventHandler('onPlayerCraftObject', root, function(ob, has, limit)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if isElement(ob) then
        local obName = getElementData(ob, 'obName')
        local x, y, z = getElementPosition(ob)

        local info = ''
        local data = {
            ['Localização: '] = ('%s (%s)'):format(getZoneName(x, y, z), getZoneName(x, y, z, true)),
            ['Limite deste jogador para este item'] = ('%s/%s'):format(tostring(has), tostring(limit)),
            ['Grupo deste jogador'] = getElementData(source, 'Group') or 'Sem grupo.',
        }

        for k, v in pairs(data) do
            info = info .. ('%s: %s\n'):format(k, v)
        end

        local embeds = {{
            ['description'] = (':hammer_pick: O jogador %s acabou de craftar um(a) ***%s*** '):format(getPlayerName(source), obName),
            ['color'] = 0xFFFF00,
            ['fields'] = {{
                name = 'Dados deste objeto:',
                value = ('```%s```'):format(info),
            }, {
                name = ('Dados de %s:'):format(getPlayerName(source)),
                value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
            }},
        }}

        sendDiscordLog('craft-object', embeds)
    end
end)

addEvent('onPlayerCraftItem', true)
addEventHandler('onPlayerCraftItem', root, function(itemName, quantity)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local info = ''
    local data = {
        ['Quantidade deste mesmo item no inventário'] = (getElementData(source, itemName) or 0),
        ['Grupo deste jogador'] = getElementData(source, 'Group') or 'Sem grupo.',
    }

    for k, v in pairs(data) do
        info = info .. ('%s: %s\n'):format(k, v)
    end

    local embeds = {{
        ['description'] = (':hammer_pick: O jogador %s acabou de craftar ***%s x%s*** '):format(getPlayerName(source), itemName, quantity),
        ['color'] = 0xFFFF00,
        ['fields'] = {{
            name = 'Informações extras:',
            value = ('```%s```'):format(info),
        }, {
            name = ('Dados de %s:'):format(getPlayerName(source)),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
        }},
    }}

    sendDiscordLog('craft-item', embeds)
end)

addEvent('onExplodeObjects', true)
addEventHandler('onExplodeObjects', root, function(hittedObjects, usedItem)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    local objInfos = {}
    if #hittedObjects > 0 then
        for k, v in ipairs(hittedObjects) do
            local owner = v.owner
            if owner then
                table.insert(objInfos, {
                    ['Dano causado'] = v.damage,
                    ['Criador'] = ('%s (%s) [%s]'):format(exports['gamemode']:GetAccountData(owner, 'lastNick') or '?', owner,
                        exports['gamemode']:GetAccountData(owner, 'Group') or '?'),
                    ['Nome do objeto'] = v.obName or 'unknown*',
                })
            end
        end
    end

    local x, y, z = getElementPosition(source)

    local embeds = {{
        ['description'] = (':bomb: O jogador %s acabou de utilizar o explosivo: ***%s***.'):format(getPlayerName(source), usedItem),
        ['color'] = 0xFF0000,
        ['fields'] = {{
            name = 'Localização da explosão:',
            value = ('%s (%s)'):format(getZoneName(x, y, z), getZoneName(x, y, z, true)),
        }, {
            name = ('Dados de %s:'):format(getPlayerName(source)),
            value = ('```IP: %s\nSerial: %s```'):format(getPlayerIP(source), getPlayerSerial(source)),
        }},
    }}

    for k, v in pairs(objInfos) do
        local info = ''

        for key, value in pairs(v) do
            info = info .. ('%s: %s\n'):format(key, value)
        end

        table.insert(embeds[1].fields, {
            name = 'Objeto Danificado',
            value = ('```%s```'):format(info),
        })
    end

    sendDiscordLog('object-damage', embeds)
end)
