-- //------------------- CONFIGS -------------------\\--
gameplayConfigs = {
    ['deadTime'] = seconds(3),
    ['timeToDestoyDeadBody'] = seconds(2),
    ['time to plants grow up'] = minutes(5),
    ['timeToDestroyPickup'] = {
        min = seconds(5),
        max = seconds(10),
    },
    ['time to respawn farms'] = {
        min = seconds(2),
        max = seconds(5),
    },
    ['anti spawnkill time'] = seconds(10),
    ['afk time'] = minutes(5),
    ['explosives'] = {
        ['C4'] = true,
        ['Satchel'] = true,
    },
    ['explosion range'] = 3,
    ['sentry range'] = 15,
    ['tempo pra nascer na cama'] = seconds(10),
    ['possibleFarmDrops'] = {'Wood', 'Stone', 'Apple', 'Pure Iron', 'Sulphur'},
}
-- //------------------- CONFIGS -------------------\\--

-- //------------------- FUNCTIONS -------------------\\--
function getGamePlayConfig(configName)
    return gameplayConfigs[configName]
end
-- //------------------- FUNCTIONS -------------------\\--

allowed_weapons_to_dec_ammo_clientside = {
    ['Rocket Launcher'] = true,
    ['Flamethrower'] = true,
    ['Grenade Launcher'] = true,
}
