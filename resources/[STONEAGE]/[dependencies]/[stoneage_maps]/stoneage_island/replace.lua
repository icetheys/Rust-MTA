txd = engineLoadTXD("a51.txd", 16647 )
engineImportTXD(txd, 16647)
dff = engineLoadDFF("a51_storeroom.dff", 16647 )
engineReplaceModel(dff, 16647)
col = engineLoadCOL ( "col.col" )
engineReplaceCOL ( col, 16647 )
engineSetModelLODDistance(16647, 500) --ID do objeto e a distância que ele irá carregar - distancia está como 500
