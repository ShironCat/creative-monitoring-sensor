local name, address = ...

local function poll()
    ws.send(textutils.serializeJSON({
        name = name,
        status = redstone.getOutput("right"),
        value = chest.list()
    }))
end

local function toggle()
    redstone.setOutput("right", not redstone.getOutput("right"))
end

local decision_table = {
    ["poll"] = poll,
    ["toggle"] = toggle
}

local function serve()
    while true do
        local request = ""
        repeat
            request = ws.receive()
        until request ~= ""
        pcall(decision_table[request])
    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
end

local ws = http.websocket(address)
local chest = peripheral.find("minecraft:chest")

parallel.waitForAny(serve, wait_for_q)

ws.close()
