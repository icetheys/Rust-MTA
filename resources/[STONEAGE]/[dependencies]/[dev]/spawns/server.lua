addEvent("createPoint", true)
function createPoint(tipo, player, x, y, z)
    local fileName = "spawns/" .. tipo .. ".lua"
    if fileExists(fileName) then
        hFile = fileOpen(fileName)
    else
        hFile = fileCreate(fileName)
        fileWrite(hFile, tipo .. ' = {\r\n')
    end
    fileSetPos(hFile, fileGetSize(hFile))
    if fileWrite(hFile, "{" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "},\r\n") then
        outputChatBox("{" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "},\r\n", player)
        for i, data in ipairs(spawns) do
            if tipo == data[1] then
                createBlip(x, y, z, 0, 1, data[2][1], data[2][2], data[2][3], 255, 0, 170, getRootElement())
                createMarker(x, y, z - 20)
            end
        end
    end
    fileClose(hFile)
end
addEventHandler("createPoint", getRootElement(), createPoint)

addEvent("onPlayerDeleteSpawnPoints", true)
function deleteSpawnPoint(player, nome)
    if fileExists("spawns/" .. tostring(nome) .. ".txt") then
        if fileDelete("spawns/" .. tostring(nome) .. ".txt") then
            outputChatBox("#00a5ff* Item [#ff0000" .. tostring(nome) .. ".txt#00a5ff] Deletado com Sucesso !", player, 0, 0, 0, true)
        end
    else
        outputChatBox("{" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z) .. "},", player)
    end
end
addEventHandler("onPlayerDeleteSpawnPoints", getRootElement(), deleteSpawnPoint)
