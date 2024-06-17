--[[
    local defaultTableStructure = {
        ['objectName'] = {
            icon = string,
            modelID = number,
            maxHealth = number,
            baseItem = bool,
            evolutionTo = string, -- this item can be evoluted ? if yes, put here new object's name
            possibleSounds = table, -- table with all possible sounds that can be played when player open inventory of this item
            craftingCusto = {
                {itemName,quantity}
            },
        rotation = number -- rotation of this obj in ground (actually only used in loot barrels)
    }
}]]

objectsDataTable = {
    ['Fundação de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Fundação',
        evolutionTo = {'Fundação de Madeira', 'Fundação de Pedra', 'Fundação de Ferro', 'Fundação Blindada'},
        baseItem = true,
        modelID = 4564,
        maxHealth = 800,
        objLevel = 0,
    },
    ['Fundação de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Fundação',
        evolutionTo = {'Fundação de Pedra', 'Fundação de Ferro', 'Fundação Blindada'},
        baseItem = true,
        modelID = 1934,
        maxHealth = 1800,
        objLevel = 1,
    },
    ['Fundação de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Fundação',
        evolutionTo = {'Fundação de Ferro', 'Fundação Blindada'},
        baseItem = true,
        modelID = 8242,
        maxHealth = 2700,
        objLevel = 2,
    },
    ['Fundação de Ferro'] = {
        craftingCusto = {{'Iron', 100}, {'Level', 15}},
        Type = 'Fundação',
        baseItem = true,
        modelID = 7526,
        maxHealth = 3400,
        objLevel = 3,
        evolutionTo = {'Fundação Blindada'},
    },
    ['Fundação Blindada'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Level', 20}},
        Type = 'Fundação',
        baseItem = true,
        modelID = 4001,
        maxHealth = 4200,
        objLevel = 4,
    },
    ['Fundação Triangular de Palito'] = {
        craftingCusto = {{'Wood', 12}},
        Type = 'Fundação Triangular',
        evolutionTo = {'Fundação Triangular de Madeira', 'Fundação Triangular de Pedra', 'Fundação Triangular de Ferro', 'Fundação Triangular Blindada'},
        baseItem = true,
        modelID = 4602,
        maxHealth = 800,
        objLevel = 0,
    },
    ['Fundação Triangular de Madeira'] = {
        craftingCusto = {{'Wood', 120}},
        Type = 'Fundação Triangular',
        evolutionTo = {'Fundação Triangular de Pedra', 'Fundação Triangular de Ferro', 'Fundação Triangular Blindada'},
        baseItem = true,
        modelID = 1898,
        maxHealth = 1800,
        objLevel = 1,
    },
    ['Fundação Triangular de Pedra'] = {
        craftingCusto = {{'Stone', 220}},
        Type = 'Fundação Triangular',
        evolutionTo = {'Fundação Triangular de Ferro', 'Fundação Triangular Blindada'},
        baseItem = true,
        modelID = 2405,
        maxHealth = 2700,
        objLevel = 2,
    },
    ['Fundação Triangular de Ferro'] = {
        craftingCusto = {{'Iron', 85}, {'Level', 15}},
        Type = 'Fundação Triangular',
        baseItem = true,
        modelID = 2410,
        maxHealth =3400,
        evolutionTo = {'Fundação Triangular Blindada'},
        objLevel = 3,
    },
    ['Fundação Triangular Blindada'] = {
        craftingCusto = {{'Metal de Alta', 90}, {'Level', 20}},
        Type = 'Fundação Triangular',
        baseItem = true,
        modelID = 4022,
        maxHealth = 4200,
        objLevel = 4,
    },
    ['Meia Fundação de Palito'] = {
        craftingCusto = {{'Wood', 10}},
        Type = 'Meia Fundação',
        evolutionTo = {'Meia Fundação de Madeira', 'Meia Fundação de Pedra', 'Meia Fundação de Ferro', 'Meia Fundação Blindada'},
        baseItem = true,
        modelID = 4188,
        maxHealth = 800,
        objLevel = 0,
    },
    ['Meia Fundação de Madeira'] = {
        craftingCusto = {{'Wood', 200}},
        Type = 'Meia Fundação',
        evolutionTo = {'Meia Fundação de Pedra', 'Meia Fundação de Ferro', 'Meia Fundação Blindada'},
        baseItem = true,
        modelID = 1022,
        maxHealth = 1800,
        objLevel = 1,
    },
    ['Meia Fundação de Pedra'] = {
        craftingCusto = {{'Stone', 100}},
        Type = 'Meia Fundação',
        evolutionTo = {'Meia Fundação de Ferro', 'Meia Fundação Blindada'},
        baseItem = true,
        modelID = 1783,
        maxHealth = 2700,
        objLevel = 2,
    },
    ['Meia Fundação de Ferro'] = {
        craftingCusto = {{'Iron', 75}, {'Level', 15}},
        Type = 'Meia Fundação',
        baseItem = true,
        modelID = 1790,
        maxHealth = 3400,
        evolutionTo = {'Meia Fundação Blindada'},
        objLevel = 3,
    },
    ['Meia Fundação Blindada'] = {
        craftingCusto = {{'Metal de Alta', 90}, {'Level', 20}},
        Type = 'Meia Fundação',
        baseItem = true,
        modelID = 2347,
        maxHealth =4200,
        objLevel = 4,
    },
    ['Parede de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Parede',
        evolutionTo = {'Parede de Madeira', 'Parede de Pedra', 'Parede de Ferro', 'Parede Blindada'},
        baseItem = true,
        modelID = 4141,
        maxHealth = 300,
        objLevel = 0,
    },
    ['Parede de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Parede',
        evolutionTo = {'Parede de Pedra', 'Parede de Ferro', 'Parede Blindada'},
        baseItem = true,
        modelID = 3455,
        maxHealth = 1000,
        objLevel = 1,
    },
    ['Parede de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Parede',
        evolutionTo = {'Parede de Ferro', 'Parede Blindada'},
        baseItem = true,
        modelID = 7490,
        maxHealth = 1800,
        objLevel = 2,
    },
    ['Parede de Ferro'] = {
        craftingCusto = {{'Iron', 100}, {'Level', 15}},
        Type = 'Parede',
        baseItem = true,
        modelID = 7528,
        maxHealth = 2600,
        evolutionTo = {'Parede Blindada'},
        objLevel = 3,
    },
    ['Parede Blindada'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Level', 20}},
        Type = 'Parede',
        baseItem = true,
        modelID = 2864,
        maxHealth = 3400,
        objLevel = 4,
    },
    ['Meia Parede de Palito'] = {
        craftingCusto = {{'Wood', 12}},
        Type = 'Meia Parede',
        evolutionTo = {'Meia Parede de Madeira', 'Meia Parede de Pedra', 'Meia Parede de Ferro', 'Meia Parede Blindada'},
        baseItem = true,
        modelID = 4079,
        maxHealth = 300,
        objLevel = 1,
    },
    ['Meia Parede de Madeira'] = {
        craftingCusto = {{'Wood', 100}},
        Type = 'Meia Parede',
        evolutionTo = {'Meia Parede de Pedra', 'Meia Parede de Ferro', 'Meia Parede Blindada'},
        baseItem = true,
        modelID = 2384,
        maxHealth = 1000,
        objLevel = 1,
    },
    ['Meia Parede de Pedra'] = {
        craftingCusto = {{'Stone', 200}},
        Type = 'Meia Parede',
        evolutionTo = {'Meia Parede de Ferro', 'Meia Parede Blindada'},
        baseItem = true,
        modelID = 4587,
        maxHealth = 1800,
        objLevel = 2,
    },
    ['Meia Parede de Ferro'] = {
        craftingCusto = {{'Iron', 85}, {'Level', 15}},
        Type = 'Meia Parede',
        baseItem = true,
        modelID = 2820,
        maxHealth = 2600,
        evolutionTo = {'Meia Parede Blindada'},
        objLevel = 3,
    },
    ['Meia Parede Blindada'] = {
        craftingCusto = {{'Metal de Alta', 90}, {'Level', 20}},
        Type = 'Meia Parede',
        baseItem = true,
        modelID = 5426,
        maxHealth = 3400,
        objLevel = 4,
    },
    ['Janela de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Janela',
        evolutionTo = {'Janela de Madeira', 'Janela de Pedra', 'Janela de Ferro', 'Janela Blindada'},
        baseItem = true,
        modelID = 5452,
        maxHealth = 300,
        objLevel = 0,
    },
    ['Janela de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Janela',
        evolutionTo = {'Janela de Pedra', 'Janela de Ferro', 'Janela Blindada'},
        baseItem = true,
        modelID = 2052,
        maxHealth = 1000,
        objLevel = 1,
    },
    ['Janela de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Janela',
        evolutionTo = {'Janela de Ferro', 'Janela Blindada'},
        baseItem = true,
        modelID = 7521,
        maxHealth = 1800,
        objLevel = 2,
    },
    ['Janela de Ferro'] = {
        craftingCusto = {{'Iron', 100}, {'Level', 15}},
        Type = 'Janela',
        baseItem = true,
        modelID = 6875,
        maxHealth = 2600,
        evolutionTo = {'Janela Blindada'},
        objLevel = 3,
    },
    ['Janela Blindada'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Level', 20}},
        Type = 'Janela',
        baseItem = true,
        modelID = 8954,
        maxHealth = 3400,
        objLevel = 4,
    },
    ['Parede para Porta de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Parede Para Porta',
        evolutionTo = {'Parede para Porta de Madeira', 'Parede para Porta de Pedra', 'Parede para Porta de Ferro', 'Parede para Porta Blindada'},
        baseItem = true,
        modelID = 4593,
        maxHealth = 300,
        objLevel = 0,
    },
    ['Parede para Porta de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Parede Para Porta',
        evolutionTo = {'Parede para Porta de Pedra', 'Parede para Porta de Ferro', 'Parede para Porta Blindada'},
        baseItem = true,
        modelID = 10031,
        maxHealth = 1000,
        objLevel = 1,
    },
    ['Parede para Porta de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Parede Para Porta',
        evolutionTo = {'Parede para Porta de Ferro', 'Parede para Porta Blindada'},
        baseItem = true,
        modelID = 7513,
        maxHealth = 1800,
        objLevel = 2,
    },
    ['Parede para Porta de Ferro'] = {
        craftingCusto = {{'Iron', 100}, {'Level', 15}},
        Type = 'Parede Para Porta',
        baseItem = true,
        modelID = 6134,
        maxHealth = 2600,
        evolutionTo = {'Parede para Porta Blindada'},
        objLevel = 3,
    },
    ['Parede para Porta Blindada'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Level', 20}},
        Type = 'Parede Para Porta',
        baseItem = true,
        modelID = 17520,
        maxHealth = 3400,
        objLevel = 4,
    },
    ['Escadas de Palito'] = {
        craftingCusto = {{'Wood', 8}},
        Type = 'Escadas',
        evolutionTo = {'Escadas de Madeira', 'Escadas de Pedra', 'Escadas de Ferro', 'Escadas Blindada'},
        baseItem = true,
        modelID = 4576,
        maxHealth = 600,
        objLevel = 0,
    },
    ['Escadas de Madeira'] = {
        craftingCusto = {{'Wood', 100}},
        Type = 'Escadas',
        evolutionTo = {'Escadas de Pedra', 'Escadas de Ferro', 'Escadas Blindada'},
        baseItem = true,
        modelID = 2276,
        maxHealth = 1500,
        objLevel = 1,
    },
    ['Escadas de Pedra'] = {
        craftingCusto = {{'Stone', 100}},
        Type = 'Escadas',
        evolutionTo = {'Escadas de Ferro', 'Escadas Blindada'},
        baseItem = true,
        modelID = 2260,
        maxHealth = 2300,
        objLevel = 2,
    },
    ['Escadas de Ferro'] = {
        craftingCusto = {{'Iron', 50}, {'Level', 15}},
        Type = 'Escadas',
        baseItem = true,
        modelID = 2123,
        maxHealth = 3100,
        evolutionTo = {'Escadas Blindada'},
        objLevel = 3,
    },
    ['Escadas Blindada'] = {
        craftingCusto = {{'Metal de Alta', 80}, {'Level', 20}},
        Type = 'Escadas',
        baseItem = true,
        modelID = 7529,
        maxHealth = 3900,
        objLevel = 4,
    },
    ['Portão de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Portão',
        evolutionTo = {'Portão de Madeira', 'Portão de Pedra', 'Portão de Ferro', 'Portão Blindado'},
        openedModels = {
            left = 5708,
            right = 6371,
        },
        baseItem = true,
        modelID = 5767,
        maxHealth = 300,
        objLevel = 0,
    },
    ['Portão de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Portão',
        evolutionTo = {'Portão de Pedra', 'Portão de Ferro', 'Portão Blindado'},
        openedModels = {
            left = 1622,
            right = 1621,
        },
        baseItem = true,
        modelID = 2958,
        maxHealth = 850,
        objLevel = 1,
    },
    ['Portão de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Portão',
        evolutionTo = {'Portão de Ferro', 'Portão Blindado'},
        openedModels = {
            left = 1518,
            right = 1944,
        },
        baseItem = true,
        modelID = 7531,
        maxHealth = 1550,
        objLevel = 2,
    },
    ['Portão de Ferro'] = {
        craftingCusto = {{'Iron', 100},{'Gears', 2}, {'Level', 15}},
        Type = 'Portão',
        openedModels = {
            left = 1613,
            right = 1614,
        },
        baseItem = true,
        modelID = 8499,
        maxHealth = 2250,
        evolutionTo = {'Portão Blindado'},
        objLevel = 3,
    },
    ['Portão Blindado'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Gears', 4}, {'Level', 20}},
        Type = 'Portão',
        openedModels = {
            left = 9523,
            right = 9595,
        },
        baseItem = true,
        modelID = 7234,
        maxHealth = 3150,
        objLevel = 4,
    },
    ['Porta de Palito'] = {
        craftingCusto = {{'Wood', 10}},
        Type = 'Porta',
        evolutionTo = {'Porta de Madeira', 'Porta de Pedra', 'Porta de Ferro', 'Porta Blindada'},
        baseItem = true,
        modelID = 6388,
        maxHealth = 250,
        objLevel = 0,
    },
    ['Porta de Madeira'] = {
        craftingCusto = {{'Wood', 100}},
        Type = 'Porta',
        evolutionTo = {'Porta de Pedra', 'Porta de Ferro', 'Porta Blindada'},
        baseItem = true,
        modelID = 2282,
        maxHealth = 700,
        objLevel = 1,
    },
    ['Porta de Pedra'] = {
        craftingCusto = {{'Stone', 150}},
        Type = 'Porta',
        evolutionTo = {'Porta de Ferro', 'Porta Blindada'},
        baseItem = true,
        modelID = 1546,
        maxHealth = 1400,
        objLevel = 2,
    },
    ['Porta de Ferro'] = {
        craftingCusto = {{'Iron', 80}, {'Gears', 1}, {'Level', 15}},
        Type = 'Porta',
        baseItem = true,
        modelID = 2096,
        maxHealth = 2100,
        evolutionTo = {'Porta Blindada'},
        objLevel = 3,
    },
    ['Porta Blindada'] = {
        craftingCusto = {{'Metal de Alta', 80}, {'Gears', 2}, {'Level', 20}},
        Type = 'Porta',
        baseItem = true,
        modelID = 6924,
        maxHealth = 3000,
        objLevel = 4,
    },
    ['Teto de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Teto',
        evolutionTo = {'Teto de Madeira', 'Teto de Pedra', 'Teto de Ferro', 'Teto Blindado'},
        baseItem = true,
        modelID = 6389,
        maxHealth = 500,
        objLevel = 0,
    },
    ['Teto de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Teto',
        evolutionTo = {'Teto de Pedra', 'Teto de Ferro', 'Teto Blindado'},
        baseItem = true,
        modelID = 10030,
        maxHealth = 1400,
        objLevel = 1,
    },
    ['Teto de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Teto',
        evolutionTo = {'Teto de Ferro', 'Teto Blindado'},
        baseItem = true,
        modelID = 1839,
        maxHealth = 2200,
        objLevel = 2,
    },
    ['Teto de Ferro'] = {
        craftingCusto = {{'Iron', 100},  {'Level', 15}},
        Type = 'Teto',
        baseItem = true,
        modelID = 1970,
        maxHealth = 3000,
        evolutionTo = {'Teto Blindado'},
        objLevel = 3,
    },
    ['Teto Blindado'] = {
        craftingCusto = {{'Metal de Alta',100}, {'Level', 20}},
        Type = 'Teto',
        baseItem = true,
        modelID = 7599,
        maxHealth = 3800,
        objLevel = 4,
    },
    ['Meio Teto de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Meio Teto',
        evolutionTo = {'Meio Teto de Madeira', 'Meio Teto de Pedra', 'Meio Teto de Ferro', 'Meio Teto Blindado'},
        baseItem = true,
        modelID = 4101,
        maxHealth = 500,
        objLevel = 0,
    },
    ['Meio Teto de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Meio Teto',
        evolutionTo = {'Meio Teto de Pedra', 'Meio Teto de Ferro', 'Meio Teto Blindado'},
        baseItem = true,
        modelID = 2102,
        maxHealth = 1400,
        objLevel = 1,
    },
    ['Meio Teto de Pedra'] = {
        craftingCusto = {{'Stone', 150}},
        Type = 'Meio Teto',
        evolutionTo = {'Meio Teto de Ferro', 'Meio Teto Blindado'},
        baseItem = true,
        modelID = 1851,
        maxHealth = 2200,
        objLevel = 2,
    },
    ['Meio Teto de Ferro'] = {
        craftingCusto = {{'Iron', 80}, {'Level', 15}},
        Type = 'Meio Teto',
        baseItem = true,
        modelID = 1969,
        maxHealth = 3000,
        evolutionTo = {'Meio Teto Blindado'},
        objLevel = 3,
    },
    ['Meio Teto Blindado'] = {
        craftingCusto = {{'Metal de Alta', 90}, {'Level', 20}},
        Type = 'Meio Teto',
        baseItem = true,
        modelID = 7507,
        maxHealth = 3800,
        objLevel = 4,
    },
    ['Floorport de Palito'] = {
        craftingCusto = {{'Wood', 15}},
        Type = 'Floorport',
        evolutionTo = {'Floorport de Madeira', 'Floorport de Pedra', 'Floorport de Ferro', 'Floorport Blindado'},
        baseItem = true,
        modelID = 4002,
        maxHealth = 500,
        objLevel = 0,
    },
    ['Floorport de Madeira'] = {
        craftingCusto = {{'Wood', 150}},
        Type = 'Floorport',
        evolutionTo = {'Floorport de Pedra', 'Floorport de Ferro', 'Floorport Blindado'},
        baseItem = true,
        modelID = 2272,
        maxHealth = 1400,
        objLevel = 1,
    },
    ['Floorport de Pedra'] = {
        craftingCusto = {{'Stone', 250}},
        Type = 'Floorport',
        evolutionTo = {'Floorport de Ferro', 'Floorport Blindado'},
        baseItem = true,
        modelID = 2258,
        maxHealth = 2200,
        objLevel = 2,
    },
    ['Floorport de Ferro'] = {
        craftingCusto = {{'Iron', 45},  {'Level', 15}},
        Type = 'Floorport',
        baseItem = true,
        modelID = 2121,
        maxHealth = 3000,
        evolutionTo = {'Floorport Blindado'},
        objLevel = 3,
    },
    ['Floorport Blindado'] = {
        craftingCusto = {{'Metal de Alta', 100}, {'Level', 20}},
        Type = 'Floorport',
        baseItem = true,
        modelID = 1486,
        maxHealth = 3800,
        objLevel = 4,
    },
    ['Teto Triangular de Palito'] = {
        craftingCusto = {{'Wood', 12}},
        Type = 'Teto Triangular',
        evolutionTo = {'Teto Triangular de Madeira', 'Teto Triangular de Pedra', 'Teto Triangular de Ferro', 'Teto Triangular Blindado'},
        baseItem = true,
        modelID = 4019,
        maxHealth = 500,
        objLevel = 0,
    },
    ['Teto Triangular de Madeira'] = {
        craftingCusto = {{'Wood', 120}},
        Type = 'Teto Triangular',
        evolutionTo = {'Teto Triangular de Pedra', 'Teto Triangular de Ferro', 'Teto Triangular Blindado'},
        baseItem = true,
        modelID = 2404,
        maxHealth = 1400,
        objLevel = 1,
    },
    ['Teto Triangular de Pedra'] = {
        craftingCusto = {{'Stone', 220}},
        Type = 'Teto Triangular',
        evolutionTo = {'Teto Triangular de Ferro', 'Teto Triangular Blindado'},
        baseItem = true,
        modelID = 1852,
        maxHealth = 2200,
        objLevel = 2,
    },
    ['Teto Triangular de Ferro'] = {
        craftingCusto = {{'Iron', 80}, {'Level', 15}},
        Type = 'Teto Triangular',
        baseItem = true,
        modelID = 1968,
        maxHealth = 3000,
        evolutionTo = {'Teto Triangular Blindado'},
        objLevel = 3,
    },
    ['Teto Triangular Blindado'] = {
        craftingCusto = {{'Metal de Alta', 90}, {'Level', 20}},
        Type = 'Teto Triangular',
        baseItem = true,
        modelID = 2752,
        maxHealth = 3800,
        objLevel = 4,
    },
    ['Wardrobe'] = {
        icon = 'objects/wardrobe.png',
        modelID = 3060,
        maxHealth = 4000,
        maxSlots = 35,
        limit = 1,
        moveOnlyWithCursor = true,
        possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        craftingCusto = {{'Wood', 50}, {'Stone', 30}},
    },
    ['Baú Pequeno'] = {
        icon = 'objects/bau_pequeno.png',
        modelID = 1946,
        maxHealth = 3000,
        maxSlots = 21,
        limit = function(lvl)
            return math.floor(1 + lvl / 2) * 2
        end,
        moveOnlyWithCursor = true,
        evolutionTo = 'Baú Grande',
        possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        craftingCusto = {{'Wood', 150}},
    },
    ['Baú Grande'] = {
        icon = 'objects/bau_grande.png',
        modelID = 1947,
        maxHealth = 3500,
        maxSlots = 35,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        moveOnlyWithCursor = true,
        possibleSounds = {'wooden1.mp3', 'wooden2.mp3', 'wooden3.mp3'},
        craftingCusto = {{'Wood', 200}, {'Iron', 30}},
    },
    ['Water Barrel'] = {
        icon = 'objects/barril.png',
        modelID = 1664,
        maxHealth = 2000,
        maxSlots = 35,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Scrap Metal', 10}, {'Level', 8}},
    },
    ['Fornalha'] = {
        icon = 'objects/fornalha.png',
        modelID = 1773,
        maxHealth = 2000,
        maxSlots = 7,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Stone', 200}, {'Wood', 100}},
    },
    ['Fogueira'] = {
        icon = 'objects/fogueira.png',
        modelID = 1909,
        maxHealth = 100,
        limit = 1,
        craftingCusto = {{'Stone', 15}, {'Sticks', 20}},
    },
    ['Mesa de pesquisa'] = {
        icon = 'objects/mesa_pesquisa.png',
        modelID = 1917,
        maxHealth = 3000,
        limit = 1,
        maxSlots = 2,
        craftingCusto = {{'Iron', 200}, {'Scrap Metal', 300}},
    },
    ['Poço'] = {
        icon = 'objects/poco.png',
        modelID = 2061,
        maxHealth = 3000,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Stone', 325}, {'Wood', 100}, {'Rope', 1}},
    },
    ['Sandbags'] = {
        icon = 'objects/sandbags.png',
        modelID = 2023,
        maxHealth = 800,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Sand', 10}},
    },
    ['Oil Barrel'] = {
        icon = 'objects/oil barrel.png',
        modelID = 935,
        maxHealth = 8000,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Scrap Metal', 10}, {'Level', 10}},
    },
    ['Barricade'] = {
        icon = 'objects/barricade.png',
        modelID = 1666,
        maxHealth = 500,
        limit = function(lvl)
            return math.floor(1 + lvl / 2)
        end,
        craftingCusto = {{'Stone', 350}, {'Iron', 10}},
    },
    ['Placa'] = {
        icon = 'objects/placa.png',
        modelID = 2078,
        maxHealth = 1000,
        limit = function(lvl)
            return math.floor(1 + lvl / 4)
        end,
        craftingCusto = {{'Iron', 50}},
    },
    ['Planter'] = {
        icon = 'objects/planter.png',
        modelID = 2177,
        maxHealth = 2000,
        limit = function(lvl)
            return math.floor(1 + lvl / 4)
        end,
        craftingCusto = {{'Wood', 400}, {'Sand', 4}, {'Level', 8}},
    },
    ['Cama'] = {
        icon = 'objects/cama.png',
        modelID = 1316,
        maxHealth = 2000,
        limit = function()
            return 1
        end,
        moveOnlyWithCursor = true,
        craftingCusto = {{'Iron', 50}, {'Cloth', 6}},
    },
    ['Workbench'] = {
        icon = 'objects/workbench.png',
        modelID = 1953,
        maxHealth = 3000,
        limit = function(lvl)
            return math.floor(1 + lvl / 4)
        end,
        craftingCusto = {{'Wood', 150}, {'Paper', 2}, {'Scrap Metal', 100}, {'Level', 5}},
    },
    ['Espetos'] = {
        icon = 'objects/espetos.png',
        modelID = 2962,
        maxHealth = 350,
        limit = function(lvl)
            return math.floor(1 + lvl / 4)
        end,
        craftingCusto = {{'Wood', 350}, {'Level', 5}},
    },
    ['Fixed Torch'] = {
        icon = 'objects/torch.png',
        modelID = 1510,
        maxHealth = 500,
        limit = function(lvl)
            return math.floor(1 + lvl / 4)
        end,
        craftingCusto = {{'Wood', 50}, {'Cloth', 1}, {'Fosforo', 1}},
    },
    ['Sentry'] = {
        icon = 'objects/sentry.png',
        modelID = 2985,
        maxHealth = 1000,
        maxAmmo = 300,
        limit = function(lvl)
            return math.floor(1 + lvl / 20)
        end,
        moveOnlyWithCursor = true,
        craftingCusto = {{'Metal de Alta', 300}, {'Tech Parts', 20},{'Gears', 4}, {'Camera', 1}, {'AK', 1}, {'Level', 10}},
    },
    ['military-barrel'] = {
        modelID = 1218,
        maxHealth = 5000,
        zOffset = 0.4,
        respawnTime = {seconds(3), seconds(4)},
        chancesToSpawn = 100,
    },
    ['military-box'] = {
        modelID = 2973,
        maxSlots = 35,
        zOffset = -0.4,
        respawnTime = {seconds(3), seconds(4)},
        chancesToSpawn = 100,
    },
    ['default-barrel'] = {
        modelID = 935,
        maxHealth = 3000,
        zOffset = -0.4,
        respawnTime = {seconds(3), seconds(4)},
        chancesToSpawn = 100,
    },
    ['flammable-barrel'] = {
        modelID = 1225,
        maxHealth = 4000,
        zOffset = -0.4,
        respawnTime = {seconds(3), seconds(4)},
        chancesToSpawn = 100,
    },
    ['industrial-barrel'] = {
        modelID = 3632,
        maxHealth = 4000,
        zOffset = -0.4,
        respawnTime = {seconds(3), seconds(4)},
        chancesToSpawn = 100,
    },
    ['default-box'] = {
        modelID = 1558,
        maxSlots = 35,
        zOffset = -0.2,
        respawnTime = {seconds(15), seconds(20)},
        chancesToSpawn = 100,
    },
}