local function serve()
    while true do
        repeat
            local request = ws.receive()
        until request == "1"
        ws.send(textutils.serializeJSON({
            name = "chest",
            value = chest.list()
        }))
    end
end

local function wait_for_q()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
end

ws = http.websocket("ws://127.0.0.1:8080/sensor")
chest = peripheral.find("minecraft:chest")

parallel.waitForAny(serve, wait_for_q)

ws.close()
