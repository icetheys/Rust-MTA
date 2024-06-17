local AccountDatas = {}
local ClearTimer = {}

-- //------------------- ACCOUNTS -------------------\\--
function createAccount(accName)
    if SQL then
        if (not GetAccount(accName)) then
            SQL:Exec('INSERT INTO `Accounts` ("Owner") VALUES (?)', accName)
            return true, 'Conta criada com sucesso!'
        else
            return false, 'Já existe uma conta com este nome.'
        end
    else
        return false, 'Falha na conexão com a database.'
    end
    return false, 'Erro desconhecido.'
end

function GetAccount(accName)
    if SQL then
        local Query = SQL:Query('SELECT * FROM `Accounts` WHERE `Owner` = ?', accName)
        return Query[1]
    end
    return false
end

ClearAccountDataCache = function(accName)
    if (type(accName) ~= 'string') then
        return false
    end
    
    if isTimer(ClearTimer[accName]) then
        killTimer(ClearTimer[accName])
    end
    
    ClearTimer[accName] = nil
    AccountDatas[accName] = nil
    
    return true
end

function GetAccountData(accName, key)
    if (not accName) or (not key) or (not SQL) then
        return false
    end

    if (not AccountDatas[accName]) then
        local Query = SQL:Query('SELECT * FROM `Accounts` WHERE `Owner` = ? LIMIT 1', accName)

        if (type(Query[1]) == 'table') then
            AccountDatas[accName] = {}
            
            for key, value in pairs(Query[1]) do
                local json = (type(value) == 'string') and fromJSON(value)

                if json then
                    AccountDatas[accName][key] = fixJSONTable(json)

                elseif (value == 'true') then
                    AccountDatas[accName][key] = true
                
                elseif (value == 'false') then
                    AccountDatas[accName][key] = false
                    
                elseif tonumber(value) then
                    AccountDatas[accName][key] = tonumber(value)

                else
                    AccountDatas[accName][key] = value
                end
            end

            if isTimer(ClearTimer[accName]) then
                killTimer(ClearTimer[accName])
            end

            ClearTimer[accName] = setTimer(function(accName)
                ClearTimer[accName] = nil
                AccountDatas[accName] = nil
            end, 60000, 1, accName)
        end
    end

    if (not AccountDatas[accName]) then
        return false
    end

    return AccountDatas[accName][key] or false
end

function accountHasAlreadyKey(accName, key)
    if SQL then
        local Query = SQL:Query('SELECT `?` FROM `Accounts` WHERE `Owner`=? AND `key` = ?', key, accName, key)
        return Query[1]
    end
end

function getPlayerAccount(p)
    return getElementData(p, 'account') or nil
end

-- //------------------- ACCOUNTS -------------------\\--
-- addCommandHandler('register', function(p, cmd, accName)
-- 	local success, string = createAccount(accName)
-- 	if success then
-- 		outputServerLog(string)
-- 	else
-- 		outputServerLog(('Falha ao criar conta (%s)'):format(string))
-- 	end
-- end)
