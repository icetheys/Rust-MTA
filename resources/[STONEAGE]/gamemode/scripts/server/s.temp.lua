-- //------------------- TEMP COMMANDS/BINDS -------------------\\--

addEventHandler('onResourceStop', resourceRoot, function()
    takeAllWeapons(root)
end)

-- addEventHandler('onPlayerJoin', root, function()
--     bindKey(source, 'j', 'down', toggleJetpack)
-- end)

-- addEventHandler('onResourceStart', resourceRoot, function()
--     for k, player in ipairs(getElementsByType('player')) do
--         bindKey(player, 'j', 'down', toggleJetpack)
--     end
-- end)

-- function toggleJetpack(p)
--     setPedWearingJetpack(p, not isPedWearingJetpack(p))
-- end

-- //------------------- TEMP COMMANDS/BINDS -------------------\\--

-- addEventHandler('onResourceStart', resourceRoot, function()
--     local file = fileCreate('test.txt')

--     local display = {}

--     for k, v in pairs(playerDataTable) do
--         if isItemOfInventory(k) then
--             local type = getItemType(k)
--             if not display[type] then
--                 display[type] = {}
--             end
--             table.insert(display[type], k)
--         end
--     end
--     for k, v in pairs(display) do
--         table.sort(display[k])
--     end

--     for k, v in pairs(display) do
--         fileWrite(file, ('\n%s:\n'):format(k))
--         for k, v in ipairs(v) do
--             fileWrite(file, ('    ["%s"] = %s\n'):format(v, translate(getRandomPlayer(), v, 'name')))
--         end
--     end

--     fileClose(file)
-- end)
