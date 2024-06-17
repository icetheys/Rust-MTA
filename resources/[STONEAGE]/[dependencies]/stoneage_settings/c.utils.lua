UI = exports['stoneage_ui']
UTILS = exports['stoneage_utils']
TRANSLATION = exports['stoneage_translations']

sW, sH = guiGetScreenSize()

translate = function(...)
    return TRANSLATION:translate(...)
end

pixels = function(...)
    return UTILS:pixels(...)
end
