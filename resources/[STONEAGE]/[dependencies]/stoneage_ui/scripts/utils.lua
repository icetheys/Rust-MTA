-- ||------------------- CONVERSION FUNCTIONS -------------------||--
function RGBToAARRGGBB(r, g, b, a)
    return ('%.2X%.2X%.2X%.2X'):format(a or 255, r, g, b)
end
-- ||------------------- CONVERSION FUNCTIONS -------------------||--