LOGS = exports['stoneage_logs']

local fileName = 'database.db'

local Init = function()

    for k, v in ipairs(getResourceACLRequests(resource)) do
        if not v.access or v.pending then
            LOGS:saveLog('error', ('Falha ao inicializar stoneage_sql (sem permissão para utilizar a função %s)'):format(v.name))
            return
        end
    end

    LOGS:saveLog('db', 'Inicializando conexão com a database...')

    if not fileExists(fileName) then
        LOGS:saveLog('db', 'Arquivo de database não encontrado, criando um novo...')
    end

    db = dbConnect('sqlite', fileName)
    if db then
        LOGS:saveLog('db', 'Conexão com a database estabelecida.')
    else
        LOGS:saveLog('db', 'Falha ao se conectar com a database, parando em 5 segundos.')
        setTimer(function()
            local _, left = getTimerDetails(sourceTimer)
            if left == 0 then
                shutdown('Falha ao se conectar com a database.')
            else
                LOGS:saveLog('db', 'Falha ao se conectar com a database, parando em ' .. left .. ' segundos.')
            end
        end, 1000, 5)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)

function Query(...)
    if db then
        local query = dbQuery(db, ...)
        local poll, rows = dbPoll(query, -1)
        if poll == nil then
            dbFree(query)
        else
            return poll, rows
        end
    end
    return {}
end

function Exec(...)
    if db then
        return dbExec(db, ...)
    end
    return false
end

function getDBTableSize(tableName)
    if db then
        local Query = Query('SELECT count(*) FROM ?', tableName)
        local result = Query[1]

        if result then
            return result['count(*)']
        end

    end
    return 'unknown*'
end
