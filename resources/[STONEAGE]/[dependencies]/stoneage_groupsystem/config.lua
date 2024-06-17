MAX_MEMBERS_IN_GROUP = 6

table.size = function(arr)
    local q = 0
    for _ in pairs(arr) do
        q = q + 1
    end
    return q
end
