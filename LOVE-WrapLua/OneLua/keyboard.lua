function love.keyboard.isDown(key)
    if key == lv1lua.keyset[1] then
        key = "circle"
    elseif key == lv1lua.keyset[2] then
        key = "cross"
    elseif key == lv1lua.keyset[3] then
        key = "triangle"
    elseif key == lv1lua.keyset[4] then
        key = "square"
    elseif key == lv1lua.keyset[5] then
        key = "l"
    elseif key == lv1lua.keyset[6] then
        key = "r"
    end
    return buttons.held[key]
end

function love.keyboard.showTextInput(table)
    if table then
        local header = {"",""}
        if table["header"] then header[1] = table["header"] end
        if table["subheader"] then header[2] = table["subheader"] end
        local text = osk.init(header[1],header[2])
        if text and text ~= "" then love.textinput(text) end
    end
end

function love.keyboard.setTextInput(table)
    love.keyboard.showTextInput(table)
end
