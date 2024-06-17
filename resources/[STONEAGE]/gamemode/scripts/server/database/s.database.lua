-- //------------------- DATABASE CONNECTION -------------------\\--
function loadDataBaseConnection()
    if SQL then
        -- SQL:Exec('DROP TABLE Accounts')
        -- SQL:Exec('DROP TABLE Objects')

        SQL:Exec('CREATE TABLE IF NOT EXISTS `Accounts` (`Owner` TEXT)')
        SQL:Exec('CREATE TABLE IF NOT EXISTS `Objects` (`ObjectID` INT, `Position` TEXT, `Name` TEXT, `Owner` TEXT, `Type` TEXT, `Others` TEXT)')

        -- SQL:Exec('INSERT INTO `Accounts` ("Owner") VALUES("CF93682723AFBD1658E8B000E9CB7594 (STAFF)")')

        for dataName, v in pairs(playerDataTable) do
            for tableName, dataType in pairs(v.savableInDB or {}) do
                local Query = SQL:Query('PRAGMA table_info(`??`)', tableName)
                local found = false
                for k, v in pairs(Query) do
                    if (v.name == dataName) then
                        found = true
                        break
                    end
                end
                if (not found) then
                    SQL:Exec('ALTER TABLE `??` ADD COLUMN `??` ??', tableName, dataName, dataType)
                    if (v.initialValue) then
                        local initialValue = v.initialValue
                        if type(initialValue) == 'function' then
                            initialValue = initialValue()
                        end
                        if (type(initialValue) == 'table') then
                            initialValue = toJSON(initialValue)
                        end
                        SQL:Exec('UPDATE `??` SET `??`=?', tableName, dataName, initialValue)
                    end
                end
            end
        end
    else
        LOGS:saveLog('db', 'Falha ao criar arquivo de database...')
        LOGS:saveLog('db', 'Cancelando inicialização.')
        cancelEvent()
    end
    -- triggerEvent('player:onTryToLogin', getRandomPlayer(), true)
end
addEventHandler('onResourceStart', resourceRoot, loadDataBaseConnection)
-- //------------------- DATABASE CONNECTION -------------------\\--
