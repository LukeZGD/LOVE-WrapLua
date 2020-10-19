lv1lua.keyenum = {16,64,128,32,8,1,8192,16384,4096,32768,256,512}
lv1lua.keyname = {"up","down","left","right","start","back"}
lv1lua.keymask = {}

for i = 1, #lv1lua.keyset do
    lv1lua.keyname[(#lv1lua.keyname)+1] = lv1lua.keyset[i]
end

function love.keyboard.isDown(key)
    for i = 1, #lv1lua.keyname do
        if key == lv1lua.keyname[i] then
            return lv1lua.keymask[i]
        end
    end
end

function love.keyboard.showTextInput(table)
    if table then
        local header = {"",""}
        if table["header"] then header[1] = table["header"] end
        if table["subheader"] then header[2] = table["subheader"] end
        Keyboard.start(header[1],header[2])
        if Keyboard.getState() == FINISHED then
            local text = Keyboard.getInput()
            if text and text ~= "" then love.textinput(text) end
        end
    end
end

function love.keyboard.setTextInput(table)
    love.keyboard.showTextInput(table)
end
