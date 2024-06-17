-- //------------------- GAME DATA -------------------\\--
dataTable = {}
--[[
    local defaultTableStructure = {
        ['dataName'] = {
            max = number, -- max quant that player can have
            initialValue = value, -- function returning value or exact value that player receive when register/respawn
            decreaseValue = value, -- function returning value or exact value that player lose (only valid for fome/sede)
            bloodLoss = value, -- function returning value or exact value of blood that player receive/lose depending on his food/thirst
            keepWhenDie = bool, -- value should be reseted to initialValue when player die?
            invSettings = { -- settings of this item on inventory
            itemType = string, -- type of this item (can be: 'weapon-primary', 'weapon-secondary', 'weapon-melee', 'food', 'drink', 'medicament', 'item')
            icon = string, -- icon's file directory
            maxStack = number, -- max stack in inventory/pickup
            possibleSounds = {string, string, ...}, -- link to custom sound when interacting with item in inventory
            attachments = {attachName1, attachName2, ...}, -- list with all avaliable attachments (max: 5) 
        },
        weaponSettings = {
            type = string, -- can be 'primary', 'secondary' or 'melee'
            weapID = number, -- weapon ID from https://wiki.multitheftauto.com/wiki/Weapons
            damage = number, -- damage
            distance = number -- distance
            shotSound = filepath
        },
        furnanceSettings = {
            receive = {
                itemName,
                number,
            },
            needed = number,
            speed = number,
        },
        craftingCusto = {
            {
                string,
                number,
            },
        },
        attach = {
            modelID = number,
            scale = number,
            bone = number,
            pos = {x, y, z, rx, ry, rz},
        }, -- it wull be used for attachments with bone_attach resource
    },
}]]

wearables = {
    ['camisa'] = true,
    ['calça'] = true,
    ['sapato'] = true,
    ['chapeu'] = true,
    ['defenseItem'] = true,
}

playerDataTable = {
    ['lastNick'] = {
        initialValue = function(player)
            if (isElement(player) and (getElementType(player) == 'player')) then
                return getPlayerName(player)
            end
            return nil
        end,
        savableInDB = {
            ['Accounts'] = 'TEXT',
        },
    },
    ['Skin'] = {
        initialValue = 0,
        savableInDB = {
            ['Accounts'] = 'TEXT',
        },
    },
    ['invOrder'] = {
        initialValue = {},
        savableInDB = {
            ['Accounts'] = 'TEXT',
            ['Objects'] = 'TEXT',
        },
    },
    ['keybarOrder'] = {
        initialValue = {},
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['pedSideOrder'] = {
        initialValue = {},
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['maxSlots'] = {
        initialValue = 28,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['equippedItem'] = {},
    ['position'] = {
        initialValue = function()
            local x, y, z = getRandomSpawnPos()
            return {
                x = x,
                y = y,
                z = z,
            }
        end,
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['fome'] = {
        max = 100,
        initialValue = function()
            return math.random(75, 100)
        end,
        decreaseValue = function()
            return math.randomf(0.3, 0.6)
        end,
        bloodLoss = function()
            return math.random(80, 300)
        end,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['sede'] = {
        max = 100,
        initialValue = function()
            return math.random(75, 100)
        end,
        decreaseValue = function()
            return math.randomf(0.4, 0.7)
        end,
        bloodLoss = function()
            return math.random(80, 250)
        end,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['blood'] = {
        max = 15000,
        initialValue = function()
            return math.random(10000, 15000)
        end,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Level'] = {
        initialValue = 1,
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Exp'] = {
        initialValue = 1,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
        keepWhenDie = true,
    },
    ['baseItems'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Wardrobe'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Mesa de pesquisa'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Baú Pequeno'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Espetos'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Baú Grande'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Water Barrel'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Fornalha'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Fogueira'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Poço'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Sandbags'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Oil Barrel'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Barricade'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Placa'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Planter'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Cama'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Workbench'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Fixed Torch'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Sentry'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Language'] = {
        initialValue = 'pt',
        keepWhenDie = true,
    },
    ['Group'] = {
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['health'] = {
        savableInDB = {
            ['Objects'] = 'INT'
        },
    },
    ['creationTime'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['wardrobe:permissions'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['wardrobe:password'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['planter:plants'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['poço:water'] = {
        savableInDB = {
            ['Objects'] = 'INT'
        },
    },
    ['sentry:ammo'] = {
        savableInDB = {
            ['Objects'] = 'INT'
        },
    },
    ['placa:text'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['obType'] = {
        savableInDB = {
            ['Objects'] = 'TEXT'
        },
    },
    ['vest_health'] = {
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['murders'] = {
        initialValue = 0,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['learnedBlueprint'] = {
        initialValue = {},
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['murders:total'] = {
        initialValue = 0,
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['deaths:total'] = {
        initialValue = 0,
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['alivetime'] = {
        initialValue = 0,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['alivetime:total'] = {
        initialValue = 0,
        keepWhenDie = true,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['Clothes'] = {
        initialValue = {
            ['shirt'] = 1,
            ['head'] = 0,
            ['pants'] = 7,
        },
        savableInDB = {
            ['Accounts'] = 'TEXT'
        },
    },
    ['brokenbone'] = {
        initialValue = nil,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['bleeding'] = {
        initialValue = 0,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    ['isDead'] = {
        initialValue = nil,
        savableInDB = {
            ['Accounts'] = 'INT'
        },
    },
    -- ITEMS
    ['AK'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/ak.png',
            maxStack = 1,
            attachments = {'attach1', 'attach2', 'attach3'},
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 30,
            damage = 4100,
            distance = 200,
            slotID = 5,
            shotSound = 'weapons/ak.wav',
        },
        researchTableNeeds = 1000,
        craftingCusto = {{'Metal de Alta', 50}, {'Wood', 100}, {'Gears', 2}, {'Duct Tape', 3}, {'Metal Spring', 3}},
        recycler = {{'Metal de Alta', 25}, {'Wood', 50}, {'Gears', 1}, {'Duct Tape', 1}, {'Metal Spring', 1}},
        ammo = {
            name = 'AK Ammo',
            magSize = 30,
        },
        attach = {
            modelID = 3100,
            scale = 1,
            bone = 12,
            pos = {0, 0.02, 0, 180, 90, 175},
        },
        attachBackward = {
            modelID = 3100,
            scale = 1,
            bone = 3,
            pos = {0.19, 0.18, 0.2, 0, 55, 180},
        },
    },
    ['AK Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/ak.png',
            maxStack = 120,
        },
        researchTableNeeds = 300,
        craftingCusto = {{'Gunpowder', 35}, {'Iron', 15}},
        recycler = {{'Gunpowder', 15}, {'Iron', 6}},
        ammoTo = {'AK'},
        modelID = 1271,
        receiveOnCraft = 30,
        maxSpawnQuantity = 15,
    },
    ['LR-300'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/lr_300.png',
            maxStack = 1,
            attachments = {'attach1', 'attach2', 'attach3'},
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 31,
            damage = 3800,
            distance = 200,
            slotID = 5,
            shotSound = 'weapons/lr-300.wav',
        },
        researchTableNeeds = 800,
        craftingCusto = {{'Metal de Alta', 35}, {'Gears', 2}, {'Duct Tape', 2}, {'Iron', 150}, {'Metal Spring', 2}},
        recycler = {{'Metal de Alta', 15}, {'Gears', 1}, {'Duct Tape', 1}, {'Iron', 65}, {'Metal Spring', 1}},
        ammo = {
            name = 'LR-300 Ammo',
            magSize = 20,
        },
        attach = {
            modelID = 3002,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 3002,
            scale = 1,
            bone = 3,
            pos = {0.19, 0.18, 0.2, 0, 55, 180},
        },
    },
    ['LR-300 Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/lr-300.png',
            maxStack = 100,
        },
        researchTableNeeds = 200,
        craftingCusto = {{'Gunpowder', 35}, {'Iron', 15}},
        recycler = {{'Gunpowder', 15}, {'Iron', 6}},
        ammoTo = {'AK'},
        modelID = 1271,
        receiveOnCraft = 20,
        maxSpawnQuantity = 10,
    },
    ['M39'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/m39.png',
            maxStack = 1,
            attachments = {'attach1', 'attach2', 'attach3'},
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 31,
            damage = 3600,
            distance = 200,
            slotID = 5,
            shotSound = 'weapons/m39.wav',
        },
        researchTableNeeds = 600,
        craftingCusto = {{'Metal de Alta', 30}, {'Gears', 2}, {'Duct Tape', 1}, {'Metal Spring', 2}},
        recycler = {{'Iron', 30}, {'Gears', 1}},
        ammo = {
            name = 'M39 Ammo',
            magSize = 25,
        },
        attach = {
            modelID = 3101,
            scale = 1.15,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 3101,
            scale = 1.15,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3101,
    },
    ['M39 Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/m39.png',
            maxStack = 125,
        },
        researchTableNeeds = 150,
        craftingCusto = {{'Gunpowder', 35}, {'Iron', 30}},
        recycler = {{'Gunpowder', 15}, {'Iron', 15}},
        receiveOnCraft = 25,
        ammoTo = {'M39'},
        modelID = 1271,
        maxSpawnQuantity = 15,
    },
    ['Rocket Launcher'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/rocket_launcher.png',
            possibleSounds = {'iron.mp3'},
            maxStack = 1,
        },
        weaponSettings = {
            type = 'primary',
            weapID = 35,
            damage = 0, -- damage comes from explosion
            distance = 200,
            slotID = 7,
        },
        researchTableNeeds = 500,
        craftingCusto = {{'Metal de Alta', 100}, {'Gears', 3}, {'Duct Tape', 4}, {'Metal Pipe', 1}},
        recycler = {{'Metal de Alta', 50}, {'Gears', 1}, {'Duct Tape', 2}},
        ammo = {
            name = 'Rocket Launcher Ammo',
            magSize = 1,
        },
        attach = {
            modelID = 1941,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 1941,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 1941,
    },
    ['Rocket Launcher Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/rocket_launcher.png',

            maxStack = 3,
        },
        researchTableNeeds = 2000,
        craftingCusto = {{'Gunpowder', 600}, {'Metal de Alta', 50}, {'Metal Pipe', 1}, {'Tech Parts', 5}},
        recycler = {{'Gunpowder', 300}, {'Metal de Alta', 15}},
        receiveOnCraft = 1,
        ammoTo = {'Rocket Launcher'},
        modelID = 345,
        maxSpawnQuantity = 1,
    },
    ['Grenade Launcher'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/grenade_launcher.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 27,
            damage = 0, -- damage comes from explosion
            distance = 100,
            slotID = 3,
            shotSound = 'weapons/grenade_launcher.wav',
        },
        researchTableNeeds = 300,
        craftingCusto = {{'Metal de Alta', 30}, {'Gears', 5}, {'Duct Tape', 2}, {'Metal Pipe', 1}},
        recycler = {{'Scrap Metal', 15}, {'Gears', 2}, {'Duct Tape', 1}},
        ammo = {
            name = 'Grenade Launcher Ammo',
            magSize = 10,
        },
        attach = {
            modelID = 1899,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 97, 180},
        },
        attachBackward = {
            modelID = 1899,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 1899,
    },
    ['Grenade Launcher Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/grenade_launcher.png',
            maxStack = 10,
        },
        researchTableNeeds = 800,
        craftingCusto = {{'Gunpowder', 150}, {'Metal de Alta', 30}},
        recycler = {{'Gunpowder', 20}, {'Metal de Alta', 5}},
        receiveOnCraft = 1,
        maxSpawnQuantity = 1,
        ammoTo = {'Grenade Launcher'},
        modelID = 2038,
    },
    ['Flamethrower'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/flamethrower.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 37,
            damage = 100,
            distance = 200,
            slotID = 7,
        },
        researchTableNeeds = 200,
        craftingCusto = {{'Scrap Metal', 100}, {'Gears', 2}, {'Duct Tape', 3}, {'Metal Pipe', 1}},
        ammo = {
            name = 'Flame Ammo',
            magSize = 1000,
        },
        attach = {
            modelID = 3003,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 3003,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3003,
    },
    ['Flame Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/flame.png',
            maxStack = 1000,
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Gunpowder', 100}, {'Animal Fat', 20}},
        receiveOnCraft = 500,
        ammoTo = {'Flamethrower'},
        modelID = 1484,
        maxSpawnQuantity = 100,
    },
    ['M249'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/m249.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 31,
            damage = 5000,
            distance = 200,
            slotID = 5,
            shotSound = 'weapons/m249.wav',
        },
        craftingCusto = {{'Scrap Metal', 20}, {'Gears', 3}, {'Duct Tape', 4}},
        ammo = {
            name = 'M249 Ammo',
            magSize = 100,
        },
        attach = {
            modelID = 3001,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 88.5, 180},
        },
        attachBackward = {
            modelID = 3001,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3001,
    },
    ['M249 Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/m249.png',
            maxStack = 200,
        },
        craftingCusto = {{'Gunpowder', 400}, {'Iron',500}},
        receiveOnCraft = 100,
        ammoTo = {'M249'},
        modelID = 1271,
        maxSpawnQuantity = 50,
    },
    ['Bolt'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/bolt.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 33,
            damage = 10000,
            distance = 3000,
            slotID = 6,
            shotSound = 'weapons/bolt.wav',
        },
        researchTableNeeds = 500,
        craftingCusto = {{'Metal de Alta', 20}, {'Gears', 2}, {'Duct Tape', 2}, {'Metal Pipe', 1}, {'Metal Spring', 4}},
        recycler = {{'Metal de Alta', 10}, {'Gears', 1}, {'Duct Tape', 1}},
        ammo = {
            name = 'AK Ammo',
            magSize = 10,
        },
        attach = {
            modelID = 3102,
            scale = 1.2,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 3102,
            scale = 1.2,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3102,
    },
    ['L96'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/l96.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 34,
            damage = 17000,
            distance = 4300,
            slotID = 6,
            shotSound = 'weapons/l96.wav',
        },
        craftingCusto = {{'Metal de Alta', 1500}, {'Gears', 10}, {'Duct Tape', 4}, {'Metal Pipe', 1}, {'Tech Parts', 20}},
        ammo = {
            name = 'Sniper Ammo',
            magSize = 10,
        },
        attach = {
            modelID = 3103,
            scale = 1.2,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 3103,
            scale = 1.2,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3103,
    },
    ['Sniper Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/sniper.png',
            maxStack = 30,
        },
        researchTableNeeds = 300,
        craftingCusto = {{'Gunpowder', 50}, {'Iron', 35}},
        recycler = {{'Gunpowder', 25}, {'Iron', 12}},
        receiveOnCraft = 10,
        ammoTo = {'Bolt', 'L96'},
        modelID = 2043,
        maxSpawnQuantity = 3,
    },
    ['Crossbow'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/crossbow.png',
            maxStack = 1,
            possibleSounds = {'wooden1.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 33,
            damage = 4000,
            distance = 200,
            slotID = 6,
            shotSound = 'weapons/crossbow.wav',
        },
        craftingCusto = {{'Wood', 100}, {'Rope', 1}},
        ammo = {
            name = 'Crossbow Ammo',
            magSize = 10,
        },
        attach = {
            modelID = 3106,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 90, 180},
        },
        attachBackward = {
            modelID = 3106,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3106,
    },
    ['Crossbow Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/crossbow.png',
            maxStack = 30,
        },
        craftingCusto = {{'Sticks', 10}, {'Stone', 5}},
        receiveOnCraft = 10,
        ammoTo = {'Crossbow'},
        modelID = 1893,
        maxSpawnQuantity = 3,
    },
    ['Spas'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/spas.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 25,
            damage = 3500,
            distance = 200,
            slotID = 3,
            shotSound = 'weapons/spas.wav',
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 30}, {'Gears', 1}, {'Duct Tape', 1}},
        recycler = {{'Iron', 15}},
        ammo = {
            name = 'Shotgun Ammo',
            magSize = 7,
        },
        attach = {
            modelID = 3104,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 185, 90, 180},
        },
        attachBackward = {
            modelID = 3104,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 3104,
    },
    ['Pump'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/pump.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 25,
            damage = 4000,
            distance = 200,
            slotID = 3,
            shotSound = 'weapons/pump.wav',
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 20}, {'Gears', 1}, {'Duct Tape', 1}},
        recycler = {{'Iron', 10}},
        ammo = {
            name = 'Shotgun Ammo',
            magSize = 7,
        },
        attach = {
            modelID = 2993,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 185, 90, 180},
        },
        attachBackward = {
            modelID = 2993,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 2993,
    },
    ['Double Barreled'] = {
        invSettings = {
            itemType = 'weapon-primary',
            icon = 'items/weapon/double-barreled.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'primary',
            weapID = 26,
            damage = 2500,
            distance = 200,
            slotID = 3,
            shotSound = 'weapons/double_barreled.wav',
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 20}, {'Gears', 2}, {'Duct Tape', 1}, {'Metal Pipe', 1}},
        recycler = {{'Iron', 10}, {'Gears', 1}},
        ammo = {
            name = 'Shotgun Ammo',
            magSize = 7,
        },
        attach = {
            modelID = 2310,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 185, 90, 180},
        },
        attachBackward = {
            modelID = 2310,
            scale = 1,
            bone = 3,
            pos = {0.15, 0.18, 0.2, 0, 55, 180},
        },
        modelID = 2310,
    },
    ['Shotgun Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/shotgun.png',
            maxStack = 56,
        },
        researchTableNeeds = 75,
        craftingCusto = {{'Gunpowder', 25}, {'Iron', 5}},
        recycler = {{'Gunpowder', 8}, {'Iron', 2}},
        receiveOnCraft = 7,
        ammoTo = {'Double Barreled', 'Spas', 'Pump'},
        modelID = 2037,
        maxSpawnQuantity = 3,
    },
    ['MP5'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/mp5.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 29,
            damage = 2900,
            distance = 200,
            slotID = 4,
            shotSound = 'weapons/mp5.wav',
        },
        researchTableNeeds = 500,
        craftingCusto = {{'Iron', 300}, {'Gears', 2}, {'Duct Tape', 2}, {'Metal Spring', 2}},
        recycler = {{'Iron', 65}, {'Gears', 1}, {'Duct Tape', 1}, {'Metal Spring', 1}},
        ammo = {
            name = 'Sub Ammo',
            magSize = 30,
        },
        attach = {
            modelID = 3105,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 3105,
            scale = 1,
            bone = 14,
            pos = {0.11, 0.05, 0, 0, 285, 90},
        },
        modelID = 3105,
    },
    ['Thompson'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/thompson.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 29,
            damage = 2700,
            distance = 200,
            slotID = 4,
            shotSound = 'weapons/thompson.wav',
        },
        researchTableNeeds = 400,
        craftingCusto = {{'Iron', 220}, {'Gears', 2}, {'Duct Tape', 1}, {'Metal Spring', 2}},
        recycler = {{'Iron', 50}, {'Gears', 1}, {'Metal Spring', 1}},
        ammo = {
            name = 'Sub Ammo',
            magSize = 30,
        },
        attach = {
            modelID = 2525,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 185, 90, 180},
        },
        attachBackward = {
            modelID = 2525,
            scale = 1,
            bone = 14,
            pos = {0.11, 0.05, 0, 0, 285, 90},
        },
        modelID = 2525,
    },
    ['Sub Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/sub.png',
            maxStack = 150,
        },
        researchTableNeeds = 200,
        craftingCusto = {{'Gunpowder', 25}, {'Iron', 15}},
        recycler = {{'Gunpowder', 10}, {'Iron', 6}},
        receiveOnCraft = 30,
        ammoTo = {'MP5', 'Thompson'},
        modelID = 2039,
        maxSpawnQuantity = 15,
    },
    ['M92'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/m92.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 22,
            damage = 3200,
            distance = 200,
            slotID = 4,
            shotSound = 'weapons/m92.wav',
        },
        researchTableNeeds = 75,
        craftingCusto = {{'Iron', 40}, {'Gears', 1}},
        recycler = {{'Iron', 20}},
        ammo = {
            name = 'Pistol Ammo',
            magSize = 10,
        },
        attach = {
            modelID = 1512,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 1512,
            scale = 1,
            bone = 14,
            pos = {0.11, 0.05, 0, 0, 285, 90},
        },
        modelID = 1512,
    },
    ['Revolver'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/revolver.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 24,
            damage = 4000,
            distance = 200,
            slotID = 2,
            shotSound = 'weapons/revolver.wav',
        },
        researchTableNeeds = 75,
        craftingCusto = {{'Iron', 25}, {'Gears', 1}, {'Duct Tape', 1}},
        recycler = {{'Iron', 10}},
        ammo = {
            name = 'Pistol Ammo',
            magSize = 7,
        },
        attach = {
            modelID = 1487,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 1487,
            scale = 1,
            bone = 14,
            pos = {0.11, 0.05, 0, 0, 285, 90},
        },
        modelID = 1487,
    },
    ['Python'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/python.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 24,
            damage = 4200,
            distance = 200,
            slotID = 2,
            shotSound = 'weapons/python.wav',
        },
        researchTableNeeds = 75,
        craftingCusto = {{'Metal de Alta', 10}, {'Gears', 2}},
        recycler = {{'Metal de Alta', 5}, {'Gears', 1}},
        ammo = {
            name = 'Pistol Ammo',
            magSize = 7,
        },
        attach = {
            modelID = 1487,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 1487,
            scale = 1,
            bone = 14,
            pos = {0.11, 0, 0, 0, 285, 90},
        },
        modelID = 1487,
    },
    ['Custom SMG'] = {
        invSettings = {
            itemType = 'weapon-secondary',
            icon = 'items/weapon/custom.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'secondary',
            weapID = 32,
            damage = 1700,
            distance = 200,
            slotID = 4,
            shotSound = 'weapons/custom_smg.wav',
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 65}, {'Gears', 1}, {'Duct Tape', 1}, {'Metal Spring', 1}},
        recycler = {{'Iron', 32}},
        ammo = {
            name = 'Pistol Ammo',
            magSize = 15,
        },
        attach = {
            modelID = 1517,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 1517,
            scale = 1,
            bone = 14,
            pos = {0.11, 0.05, 0, 0, 285, 90},
        },
        modelID = 1517,
    },
    ['Pistol Ammo'] = {
        invSettings = {
            itemType = 'ammo',
            icon = 'items/ammo/pistol.png',
            maxStack = 75,
        },
        researchTableNeeds = 75,
        craftingCusto = {{'Gunpowder', 15}, {'Iron', 10}},
        recycler = {{'Gunpowder', 6}, {'Iron', 5}},
        receiveOnCraft = 10,
        ammoTo = {'Custom SMG', 'Python', 'Revolver', 'M92'},
        modelID = 2039,
        maxSpawnQuantity = 10,
    },
    -- ['Beans Can Grenade'] = {
    --     invSettings = {
    --         itemType = 'weapon-melee',
    --         icon = 'items/weapon/beans_can_grenade.png',
    --         maxStack = 1,
    --     },
    --     weaponSettings = {
    --         type = 'melee',
    --         weapID = 18,
    --         damage = 1,
    --         distance = 200,
    --         slotID = 8,
    --     },
    --     researchTableNeeds = 300,
    --     craftingCusto = {{'Empty Beans Can', 1}, {'Gunpowder', 40}, {'Iron', 65}},
    --     recycler = {{'Gunpowder', 20}, {'Iron', 32}},
    --     attach = {
    --         modelID = 2601,
    --         scale = 1,
    --         bone = 12,
    --         pos = {-0.05, 0.05, 0.05, 180, 90, 180},
    --     },
    --     receiveOnCraft = 1,
    --     ammoTo = {'Custom SMG', 'Python', 'Revolver', 'M92'},
    --     modelID = 2601,
    -- },
    ['Grenade'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/grenade.png',
            maxStack = 1,
        },
        weaponSettings = {
            type = 'melee',
            weapID = 16,
            damage = 100000,
            distance = 20,
            slotID = 8,
        },
        researchTableNeeds = 1200,
        craftingCusto = {{'Metal de Alta', 15}, {'Gears', 3}, {'Duct Tape', 5}, {'Gunpowder', 400}},
        recycler = {{'Iron', 65}, {'Gears', 1}, {'Duct Tape', 2}, {'Gunpowder', 100}},
        attach = {
            modelID = 342,
            scale = 1,
            bone = 12,
            pos = {-0.05, 0.05, 0.05, 180, 90, 180},
        },
        receiveOnCraft = 1,
        modelID = 342,
    },
    -- ['Tear Gas'] = {
    --     invSettings = {
    --         itemType = 'weapon-melee',
    --         icon = 'items/weapon/tear_gas.png',
    --         maxStack = 1,
    --     },
    --     weaponSettings = {
    --         type = 'melee',
    --         weapID = 17,
    --         damage = 100,
    --         distance = 20,
    --         slotID = 2,
    --     },
    --     craftingCusto = {
    --         {
    --             'Iron',
    --             20,
    --         }, {
    --             'Gears',
    --             1,
    --         }, {
    --             'Duct Tape',
    --             2,
    --         },
    --     },
    --     attach = {
    --         modelID = 343,
    --         scale = 1,
    --         bone = 12,
    --         pos = {-0.05, 0.05, 0.05, 180, 90, 180},
    --     },
    --     receiveOnCraft = 1,
    -- },
    ['Hammer'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/hammer.png',
            maxStack = 1,
            possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 7,
            damage = 1000,
            distance = 20,
            slotID = 1,
        },
        craftingCusto = {{'Wood', 80}},
        recycler = {{'Wood', 40}},
        attach = {
            modelID = 2996,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 2996,
            scale = 1,
            bone = 13,
            pos = {-0.05, 0.05, 0.35, 5, 180, 90},
        },
        receiveOnCraft = 1,
    },
    ['Torch'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/torch.png',
            maxStack = 1,
            possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 1,
            damage = 1000,
            distance = 20,
            slotID = 1,
        },
        craftingCusto = {{'Wood', 100}, {'Cloth', 1}},
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2995,
            scale = 1.2,
            bone = 11,
            pos = {0, 0, 0.14, 0, 70, 0},
        },
        receiveOnCraft = 1,
    },
    ['Chainsaw'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/chainsaw.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 9,
            damage = 6000,
            distance = 1,
            slotID = 1,
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 40}, {'Gears', 3}, {'Scrap Metal', 10}},
        recycler = {{'Iron', 20}, {'Gears', 1}, {'Scrap Metal', 5}},
        attach = {
            modelID = 2997,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        receiveOnCraft = 1,
    },
    ['JackHammer'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/jackhammer.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 9,
            damage = 5000,
            distance = 1,
            slotID = 1,
        },
        researchTableNeeds = 125,
        craftingCusto = {{'Iron', 40}, {'Gears', 3}, {'Scrap Metal', 10}},
        recycler = {{'Iron', 20}, {'Gears', 1}, {'Scrap Metal', 5}},
        attach = {
            modelID = 3000,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        receiveOnCraft = 1,
    },
    ['Shovel'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/shovel.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 6,
            slotID = 1,
            damage = 2000,
            distance = 1,
        },
        craftingCusto = {{'Wood', 60}, {'Iron', 15}},
        recycler = {{'Wood', 30}, {'Iron', 6}},
        attach = {
            modelID = 337,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 337,
            scale = 1,
            bone = 3,
            pos = {0, 0, 0, 30, 0, 270},
        },
        receiveOnCraft = 1,
    },
    ['Hatchet'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/hatchet.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 2,
            slotID = 1,
            damage = 2000,
            distance = 1,
        },
        craftingCusto = {{'Wood', 60}, {'Stone', 25}},
        recycler = {{'Wood', 30}, {'Stone', 12}},
        attach = {
            modelID = 2998,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 2998,
            scale = 1,
            bone = 13,
            pos = {-0.05, 0.05, 0.35, 5, 180, 90},
        },
        receiveOnCraft = 1,
    },
    ['Pickaxe'] = {
        invSettings = {
            itemType = 'weapon-melee',
            icon = 'items/weapon/pickaxe.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        weaponSettings = {
            type = 'melee',
            weapID = 2,
            damage = 2000,
            distance = 1,
            slotID = 1,
        },
        craftingCusto = {{'Wood', 60}, {'Stone', 25}},
        recycler = {{'Wood', 30}, {'Stone', 12}},
        attach = {
            modelID = 2999,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0, 180, 87.5, 180},
        },
        attachBackward = {
            modelID = 2999,
            scale = 1,
            bone = 13,
            pos = {-0.05, 0.05, 0.35, 5, 180, 90},
        },
        receiveOnCraft = 1,
    },
    ['Sentry Ammo'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/ammo/sentry.png',
            maxStack = 120,
        },
        researchTableNeeds = 300,
        craftingCusto = {{'Gunpowder', 60}, {'Metal de Alta', 20}},
        recycler = {{'Gunpowder', 30}, {'Metal de Alta', 10}},
        modelID = 1271,
        receiveOnCraft = 30,
        maxSpawnQuantity = 10,
    },
    ['Battery'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/battery.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Tech Parts', 1}, {'Iron', 30}},
        attach = {
            modelID = 1746,
            scale = 0.2,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Scrap Metal'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/scrap_metal.png',
            maxStack = 3000,
            possibleSounds = {'iron.mp3'},
        },
        maxSpawnQuantity = 20,
        attach = {
            modelID = 3117,
            scale = 0.2,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Duct Tape'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/duct_tape.png',
            maxStack = 10,
            possibleSounds = {'pano.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1579,
            scale = 1,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Rope'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/rope.png',
            maxStack = 10,
            possibleSounds = {'pano.mp3'},
        },
        recycler = {{'Cloth', 1}},
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1579,
            scale = 1,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Camera'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/camera.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Tech Parts', 1}, {'Iron', 50}},
        attach = {
            modelID = 367,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0.05, 90, 0, 175},
        },
    },
    ['Gunpowder'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/gunpowder.png',
            maxStack = 1000
        },
        receiveOnCraft = 100,
        craftingCusto = {{'Sulphur', 200}, {'Coal', 300}},
        maxSpawnQuantity = 20,
    },
    ['Sewing Kit'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/sewing_kit.png',
            maxStack = 10,
            possibleSounds = {'pano.mp3'},
        },
        recycler = {{'Cloth', 2}, {'Rope', 1}},
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2694,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0.05, 90, 0, 175},
        },
    },
    ['Road Signs'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/road_signs.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Scrap Metal', 2}},
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1425,
            scale = 0.3,
            bone = 12,
            pos = {0, 0, 0.05, 90, 0, 175},
        },
    },
    ['Satchel'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/satchel.png',
            maxStack = 3,
        },
        maxSpawnQuantity = 1,
        researchTableNeeds = 1000,
        craftingCusto = {{'Iron', 300}, {'Gears', 2}, {'Duct Tape', 3}, {'Gunpowder', 320}, {'Tech Parts', 2}},
        recycler = {{'Iron', 40}, {'Gears', 1}, {'Duct Tape', 1}, {'Gunpowder', 40}, {'Tech Parts', 1}},
        attach = {
            modelID = 363,
            scale = 1,
            bone = 12,
            pos = {0.05, 0, 0, 180, 0, 175},
        },
        receiveOnCraft = 1,
    },
    ['C4'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/c4.png',
            maxStack = 3
        },
        researchTableNeeds = 1500,
        craftingCusto = {{'Metal de Alta', 20}, {'Gears', 2}, {'Duct Tape', 5}, {'Gunpowder', 400}, {'Tech Parts', 2}, {'Clock', 1}},
        recycler = {{'Metal de Alta', 15}, {'Gears', 1}, {'Duct Tape', 2}, {'Gunpowder', 200}, {'Tech Parts', 1}},
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1654,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0.13, 30, 80, 0},
        },
        receiveOnCraft = 1,
    },
    ['KeyCard'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/keycard.png',
            maxStack = 2,
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1581,
            scale = 0.2,
            bone = 11,
            pos = {0.04, 0.02, 0.1, 320, 0, 0},
        },
    },
    ['Coal'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/coal.png',
            maxStack = 1000,
        },
        attach = {
            modelID = 2040,
            scale = 0.3,
            bone = 12,
            pos = {0.02, 0, 0.05, 180, 0, 175},
        },
        maxSpawnQuantity = 30,
    },
    ['Clock'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/clock.png',
            maxStack = 3,
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 327,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Toolbox'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/toolbox.png',
            maxStack = 1,
        },
        attach = {
            modelID = 2969,
            scale = 0.5,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Empty Gallon'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/empty_gallon.png',
            maxStack = 1,
        },
        attach = {
            modelID = 1650,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Gallon'] = {
        invSettings = {
            itemType = 'vehiclePart',
            icon = 'items/gallon.png',
            maxStack = 1,
        },
        attach = {
            modelID = 1650,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Metal Pipe'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/metal_pipe.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        maxSpawnQuantity = 1,
        recycler = {{'Scrap Metal', 20}, {'Iron', 20}},
        attach = {
            modelID = 3042,
            scale = 0.1,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Tech Parts'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/tech_parts.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        maxSpawnQuantity = 2,
        recycler = {{'Scrap Metal', 30}},
        attach = {
            modelID = 934,
            scale = 0.03,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Metal Spring'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/metal_spring.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        maxSpawnQuantity = 2,
        recycler = {{'Scrap Metal', 20}, {'Iron', 10}},
        attach = {
            modelID = 933,
            scale = 0.03,
            bone = 12,
            pos = {0.02, 0, 0.15, 180, 0, 175},
        },
    },
    ['Gears'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/gears.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        maxSpawnQuantity = 2,
        recycler = {{'Scrap Metal', 5}, {'Iron', 10}},
        attach = {
            modelID = 915,
            scale = 0.5,
            bone = 12,
            pos = {0.02, 0, 0.05, 180, 0, 175},
        },
    },
    ['Cloth'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/cloth.png',
            maxStack = 50,
            possibleSounds = {'pano.mp3'},
        },
        maxSpawnQuantity = 4,
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Map'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/map.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        initialValue = 1,
        attach = {
            modelID = 2855,
            scale = 0.5,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Radial'] = {
        invSettings = {
            itemType = 'defenseItem',
            icon = 'items/radial.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        craftingCusto = {{'Sewing Kit', 1}, {'Cloth', 20}, {'Duct Tape', 2}, {'Mask', 1}},
        recycler = {{'Cloth', 10}, {'Duct Tape', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Vest'] = {
        invSettings = {
            itemType = 'defenseItem',
            icon = 'items/vest.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        researchTableNeeds = 800,
        craftingCusto = {{'Sheet Metal', 1}, {'Metal de Alta', 30}, {'Cloth', 10}, {'Sewing Kit', 2}},
        recycler = {{'Metal de Alta', 15}, {'Cloth', 5}, {'Sewing Kit', 1}},
        attach = {
            modelID = 1922,
            scale = 1,
            bone = 12,
            pos = {0.05, 0, 0.2, 180, 90, 200},
        },
        attachDefense = {
            modelID = 1922,
            scale = 1,
            bone = 3,
            pos = {0.01, -0.01, -0.175, 6.8, 0, 180},
        },
    },
    ['Helmet'] = {
        researchTableNeeds = 1000,
        invSettings = {
            itemType = 'defenseItem',
            icon = 'items/helmet.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        craftingCusto = {{'Road Signs', 1}, {'Metal de Alta', 35}, {'Cloth', 8}, {'Sewing Kit', 2}},
        recycler = {{'Sheet Metal', 1}, {'Metal de Alta', 5}, {'Cloth', 4}, {'Sewing Kit', 1}},
        attach = {
            modelID = 2254,
            scale = 1,
            bone = 12,
            pos = {0, 0, 0.08, 0, 0, 0},
        },
        attachDefense = {
            modelID = 2254,
            scale = 1,
            bone = 1,
            pos = {0, 0, 0.08, 0, 0, 0},
        },
    },
    ['Mask'] = {
        invSettings = {
            itemType = 'defenseItem',
            icon = 'items/mask.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 1604,
            scale = 1.1,
            bone = 12,
            pos = {0, 0, 0, 0, 0, 0},
        },
        attachDefense = {
            modelID = 1604,
            scale = 1.1,
            bone = 1,
            pos = {0, 0, 0.07, 0, 0, 90},
        },
    },
    ['Animal Fat'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/animal_fat.png',
            maxStack = 5,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2803,
            scale = 0.15,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Empty Beans Can'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/empty_beans_can.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        recycler = {{'Iron', 5}},
        attach = {
            modelID = 2601,
            scale = 1,
            bone = 12,
            pos = {-0.075, 0, 0.085, 180, 0, 175},
        },
    },
    ['Tire'] = {
        invSettings = {
            itemType = 'vehiclePart',
            icon = 'items/tire.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        recycler = {{'Iron', 10}},
        attach = {
            modelID = 1073,
            scale = 0.5,
            bone = 12,
            pos = {-0.075, 0, 0.085, 90, 0, 175},
        },
    },
    ['Engine'] = {
        invSettings = {
            itemType = 'vehiclePart',
            icon = 'items/engine.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Metal de Alta', 3}, {'Iron', 30}},
        attach = {
            modelID = 929,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Vehicle Battery'] = {
        invSettings = {
            itemType = 'vehiclePart',
            icon = 'items/vehicle_battery.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Scrap Metal', 7}, {'Iron', 15}},
        attach = {
            modelID = 920,
            scale = 0.2,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Parts'] = {
        invSettings = {
            itemType = 'vehiclePart',
            icon = 'items/parts.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        recycler = {{'Iron', 20}, {'Scrap Metal', 20}},
        attach = {
            modelID = 1008,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Paper'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/paper.png',
            maxStack = 3,
            possibleSounds = {'pano.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2059,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Seed Corn'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/seed_corn.png',
            maxStack = 10,
            possibleSounds = {'sementes.mp3'},
        },
        maxSpawnQuantity = 3,
        attach = {
            modelID = 2821,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Corn'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/corn.png',
            maxStack = 3,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2821,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Seed Potato'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/seed_potato.png',
            maxStack = 10,
            possibleSounds = {'sementes.mp3'},
        },
        maxSpawnQuantity = 3,
        attach = {
            modelID = 2821,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Potato'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/potato.png',
            maxStack = 3,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1213,
            scale = 0.5,
            bone = 12,
            pos = {0, 0.05, 0.05, 70, 150, 50},
        },
    },
    ['Seed Pumpkin'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/seed_pumpkin.png',
            maxStack = 10,
            possibleSounds = {'sementes.mp3'},
        },
        maxSpawnQuantity = 3,
        attach = {
            modelID = 2821,
            scale = 1,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Pumpkin'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/pumpkin.png',
            maxStack = 3,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1974,
            scale = 0.25,
            bone = 12,
            pos = {0.02, 0, 0.085, 180, 0, 175},
        },
    },
    ['Empty Bottle'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/empty_bottle.png',
            maxStack = 1,
        },
        attach = {
            modelID = 1484,
            scale = 1,
            bone = 12,
            pos = {0, 0, -0.01, 360, 330, 360},
        },
    },
    ['Meat Cooked'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/meat_cooked.png',
            maxStack = 3,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2806,
            scale = 0.2,
            bone = 12,
            pos = {0, 0, 0.07, 20, 0, 130},
        },
    },
    ['Raw Meat'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/raw_meat.png',
            maxStack = 3,
            possibleSounds = {'food.mp3'},
        },
        maxSpawnQuantity = 1,
        furnanceSettings = {
            receive = {'Meat Cooked', 1},
            needed = 1,
            speed = 35,
        },
        attach = {
            modelID = 2804,
            scale = 0.5,
            bone = 12,
            pos = {0, 0, 0, 70, 160, 100},
        },
    },
    ['Planner'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/planner.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        craftingCusto = {{'Wood', 50}},
        attach = {
            modelID = 3017,
            scale = 0.5,
            bone = 12,
            pos = {0, 0, 0.08, 200, 0, 10},
        },
    },
    ['Fosforo'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/fosforo.png',
            maxStack = 50,
        },
        attach = {
            modelID = 2039,
            scale = 1,
            bone = 12,
            pos = {0.07, 0, 0.08, 0, 0, 0},
        },
        maxSpawnQuantity = 12,
    },
    ['Sticks'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/sticks.png',
            maxStack = 50,
            possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        },
        craftingCusto = {{'Wood', 50}},
        receiveOnCraft = 10,
        maxSpawnQuantity = 7,
        attach = {
            modelID = 842,
            scale = 0.1,
            bone = 12,
            pos = {0.07, 0, 0.06, 0, 100, 100},
        },
    },
    ['Sheet Metal'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/sheet_metal.png',
            maxStack = 10,
            possibleSounds = {'iron.mp3'},
        },
        craftingCusto = {{'Scrap Metal', 50}, {'Iron', 100}},
        recycler = {{'Iron', 15}, {'Scrap Metal', 5}},
        receiveOnCraft = 1,
        maxSpawnQuantity = 1,
        attach = {
            modelID = 3117,
            scale = 0.1,
            bone = 12,
            pos = {0.07, 0, 0.06, 120, 70, 110},
        },
    },
    ['Locker'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/locker.png',
            maxStack = 1,
            possibleSounds = {'iron.mp3'},
        },
        craftingCusto = {{'Scrap Metal', 20}, {'Tech Parts', 2}},
        attach = {
            modelID = 2886,
            scale = 0.5,
            bone = 12,
            pos = {0.03, 0.05, 0.11, 120, 70, 210},
        },
    },
    ['Wood'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/wood.png',
            maxStack = 1000,
            possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        },
        furnanceSettings = {
            receive = {'Coal', 1},
            needed = 1,
            speed = 20,
        },
        attach = {
            modelID = 1463,
            scale = 0.2,
            bone = 12,
            pos = {0, 0.05, 0.05, 0, 180, 175},
        },
    },
    ['Minerio de Enxofre'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/minerio_enxofre.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
        furnanceSettings = {
            receive = {'Sulphur', 1},
            needed = 1,
            speed = 35,
        },
    },
    ['Sulphur'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/sulphur.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
    },
    ['Sand'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/sand.png',
            maxStack = 3,
            possibleSounds = {'pano.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 2060,
            scale = 0.5,
            bone = 12,
            pos = {0.03, 0.05, 0.11, 120, 70, 270},
        },
    },
    ['Stone'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/stone.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
        attach = {
            modelID = 868,
            scale = 0.1,
            bone = 12,
            pos = {0.03, 0.05, 0.11, 120, 70, 270},
        },
    },
    ['Fiber'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/fiber.png',
            maxStack = 100,
        },
        attach = {
            modelID = 804,
            scale = 0.1,
            bone = 12,
            pos = {0.03, 0.05, 0.11, 120, 70, 270},
        },
    },
    ['Pure Iron'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/pure_iron.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
        furnanceSettings = {
            receive = {'Iron', 1},
            needed = 1,
            speed = 100,
        },
        attach = {
            modelID = 2936,
            scale = 0.2,
            bone = 12,
            pos = {-0.01, 0.02, 0.11, 290, 90, 320},
        },
    },
    ['Iron'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/iron.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
        attach = {
            modelID = 2936,
            scale = 0.2,
            bone = 12,
            pos = {-0.01, 0.02, 0.11, 290, 90, 320},
        },
    },
    ['Metal de Alta'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/metal_alta.png',
            maxStack = 300,
            possibleSounds = {'rochas.mp3'},
        },
        attach = {
            modelID = 2936,
            scale = 0.2,
            bone = 12,
            pos = {-0.01, 0.02, 0.11, 290, 90, 320},
        },
        maxSpawnQuantity = 3,
    },
    ['Minerio Metal de Alta'] = {
        invSettings = {
            itemType = 'item',
            icon = 'items/minerio_metal_alta.png',
            maxStack = 1000,
            possibleSounds = {'rochas.mp3'},
        },
        furnanceSettings = {
            receive = {'Metal de Alta', 1},
            needed = 1,
            speed = 200,
        },
        attach = {
            modelID = 2936,
            scale = 0.2,
            bone = 12,
            pos = {-0.01, 0.02, 0.11, 290, 90, 320},
        },
    },
    ['Bandage'] = {
        invSettings = {
            itemType = 'medicament',
            icon = 'items/bandage.png',
            maxStack = 3,
            maxSpawnQuantity = 1,
            possibleSounds = {'pano.mp3'},
        },
        initialValue = 3,
        craftingCusto = {{'Cloth', 1}},
        attach = {
            modelID = 1578,
            scale = 2,
            bone = 12,
            pos = {-0.01, 0.02, 0.11, 280, 70, 260},
        },
    },
    ['Morphine'] = {
        invSettings = {
            itemType = 'medicament',
            icon = 'items/morphine.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        initialValue = 1,
        attach = {
            modelID = 1579,
            scale = 2,
            bone = 12,
            pos = {0.02, 0.02, 0.13, 0, 0, 0},
        },
    },
    ['Blood Kit'] = {
        invSettings = {
            itemType = 'medicament',
            icon = 'items/blood_kit.png',
            maxStack = 3,
            possibleSounds = {'pano.mp3'},
        },
        maxSpawnQuantity = 1,
        attach = {
            modelID = 1580,
            scale = 1,
            bone = 12,
            pos = {0.01, 0.06, 0.13, 70, 0, 0},
        },
    },
    ['Frist Aid'] = {
        invSettings = {
            itemType = 'medicament',
            icon = 'items/frist_aid.png',
            maxStack = 3,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 2891,
            scale = 1,
            bone = 12,
            pos = {0.01, 0.06, 0.13, 70, 0, 0},
        },
    },
    ['Water'] = {
        invSettings = {
            itemType = 'drink',
            icon = 'items/water.png',
            maxStack = 1,
        },
        attach = {
            modelID = 1484,
            scale = 1,
            bone = 12,
            pos = {0, 0, -0.01, 360, 330, 360},
        },
    },
    ['Apple'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/apple.png',
            maxStack = 50,
            possibleSounds = {'food.mp3'},
        },
        attach = {
            modelID = 328,
            scale = 1,
            bone = 12,
            pos = {0.01, 0.05, 0.06, 0, 0, 0},
        },
        maxSpawnQuantity = 2,
    },
    ['Beans Can'] = {
        invSettings = {
            itemType = 'food',
            icon = 'items/beans_can.png',
            maxStack = 1,
            possibleSounds = {'food.mp3'},
        },
        attach = {
            modelID = 2601,
            scale = 1,
            bone = 12,
            pos = {-0.075, 0, 0.085, 180, 0, 175},
        },
    },
    ['Camisa 1'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_2.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 2,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 2'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_4.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        recycler = {{'Cloth', 1}},
        clothSettings = {
            type = 0,
            id = 4,
        },
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 3'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_5.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 5,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 4'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_10.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 10,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 5'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_11.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 11,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 6'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_17.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 17,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 7'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_19.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 19,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 8'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_20.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 20,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 9'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_26.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 26,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 10'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_28.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 28,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 11'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_35.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 35,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 12'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_37.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 37,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 13'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_39.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 39,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 14'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_42.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 36,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Camisa 15'] = {
        invSettings = {
            itemType = 'camisa',
            icon = 'roupas/0_45.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 0,
            id = 45,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 1'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_3.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 3,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 2'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_5.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 5,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 3'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_6.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 6,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 4'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_7.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 7,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 5'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_13.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 13,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 6'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_29.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 29,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 7'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_16.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 16,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 8'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_34.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 34,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 9'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_36.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 36,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 10'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_17.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 17,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Calca 11'] = {
        invSettings = {
            itemType = 'calça',
            icon = 'roupas/2_15.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 2,
            id = 15,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 1'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_4.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 4,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 2'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_6.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 6,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 3'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_11.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 11,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 4'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_13.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 13,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 5'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_20.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 20,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 6'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_29.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 29,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Sapato 7'] = {
        invSettings = {
            itemType = 'sapato',
            icon = 'roupas/3_31.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 3,
            id = 31,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 1'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_10.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 10,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 2'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_11.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 11,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 3'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_22.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 22,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 4'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_27.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 27,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 5'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_32.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 32,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 6'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_33.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 33,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['Chapeu 7'] = {
        invSettings = {
            itemType = 'chapeu',
            icon = 'roupas/16_36.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        clothSettings = {
            type = 16,
            id = 36,
        },
        recycler = {{'Cloth', 1}},
        attach = {
            modelID = 2846,
            scale = 0.5,
            bone = 12,
            pos = {-0.05, 0, -0.075, 180, 90, 175},
        },
    },
    ['AK:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/ak.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Beans Can Grenade:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/beans_can_grenade.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Bolt:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/bolt.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Chainsaw:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/chainsaw.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Custom SMG:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/custom.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Double Barreled:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/double-barreled.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Flamethrower:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/flamethrower.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Grenade Launcher:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/grenade_launcher.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Grenade:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/grenade.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['JackHammer:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/jackhammer.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['L96:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/l96.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['LR-300:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/lr_300.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['M39:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/m39.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['M92:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/m92.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['M249:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/m249.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['MP5:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/mP5.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Pump:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/pump.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Python:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/python.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Revolver:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/revolver.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Rocket Launcher:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/rocket_launcher.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Spas:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/spas.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Thompson:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/weapon/Thompson.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['AK Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/ak.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Flame Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/flame.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Grenade Launcher Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/grenade_launcher.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['LR-300 Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/lr-300.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['M39 Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/m39.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Sniper Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/sniper.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['M249 Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/m249.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Pistol Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/pistol.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Rocket Launcher Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/rocket_launcher.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Sentry Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/sentry.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Shotgun Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/shotgun.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Sub Ammo:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/sub.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Sniper:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/sniper.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Sub:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/ammo/sub.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Satchel:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/satchel.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['C4:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/c4.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Helmet:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/helmet.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
    ['Vest:BLUEPRINT'] = {
        invSettings = {
            itemType = 'blueprint',
            icon = 'blueprints/vest.png',
            maxStack = 1,
            possibleSounds = {'pano.mp3'},
        },
        attach = {
            modelID = 3111,
            scale = 0.2,
            bone = 12,
            pos = {0.05, 0.07, -0.02, 100, 5, 0},
        },
    },
}
-- //------------------- GAME DATA -------------------\\--

-- for k, v in pairs(playerDataTable) do
--     if v.craftingCusto then
--         playerDataTable[k].craftingCusto = {
--             {'level',
--             0,}
--         }
--     end
-- end
