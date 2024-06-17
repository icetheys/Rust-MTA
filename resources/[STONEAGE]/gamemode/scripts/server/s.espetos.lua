initEspeto = function(ob)
    if isElement(ob) then
        local x, y, z = getElementPosition(ob)
        local col = createColSphere(x, y, z, 1.5)
        attachElements(col, ob, 0, 0.3, 0.7)
        setElementParent(col, ob)
        addEventHandler('onColShapeHit', col, onHitEspeto)
    end
end

onHitEspeto = function(elem, sameDim)
    if (getElementType(elem) == 'player') and sameDim and (not isAdmin(elem)) then
        if (not getElementData(elem, 'isDead')) then
            setElementData(elem, 'bleeding', (getElementData(elem, 'bleeding') or 0) + math.random(2500, 4500))
        end
    end
end
