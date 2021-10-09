--[[
    
    Network Module For Communication On Client

    PostMessage(Key,Message) -- Will send a message along with a key for identification
    BindToServerMessage(Key,Function) -- Will run a provided function everytime server sends a message with key.

]]
local Network = {}

--Vars
local PlayerManager

--Our Remote
local NetworkRemote = game.ReplicatedStorage:FindFirstChild("CakeGame:8508E46C-B167-4ABC-B1BE-7B84204A4363")


function Network:PostMessage(Key, Message)
    local S,E
    repeat
        S,E = pcall(function()
            NetworkRemote:FireServer(Key,Message)
        end)
    until S
end

--On Reciveing
local Functions = {}

function Network:BindToServerMessage(Key,Function)
    Functions[Key] = Function
end

NetworkRemote.OnClientEvent:Connect(function(key,Message)
    --Execute function
    Functions[key](Message)
end)

return Network