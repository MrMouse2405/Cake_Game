--[[
    
    Network Module For Communication

    SetPlayerManager(PlayerManager) -- used for setting current player manager instance

    PostMessage(Player,Key,Message) -- Will send a message along with a key for identification
    BindToClientMessage(Key,Function) -- Will run a function provided function everytime client sends a message with key.

]]
local Network = {}

--Vars
local PlayerManager

--Our Remote
local NetworkRemote = Instance.new("RemoteEvent")
NetworkRemote.Name  = "CakeGame:8508E46C-B167-4ABC-B1BE-7B84204A4363"
NetworkRemote.Parent = game.ReplicatedStorage

--Methods
function Network.setPlayerManager(plrMgr)
    PlayerManager = plrMgr
end

function Network.postMessage(Client :Player,Key, Message)
    local S,E
    repeat
        S,E = pcall(function()
            NetworkRemote:FireClient(Client,Key,Message)
        end)
    until S
end

--On Reciveing
local Functions = {}

function Network.bindToClientMessage(Key,Function)
    Functions[Key] = Function
end

NetworkRemote.OnServerEvent:Connect(function(Player,key,Message)
    
    Player = PlayerManager:FindPlayer(Player)

    --if spamming, its a hacker, kick it out.
    if Player.LastPing - tick() < 1 then
        Player():Kick()
        return
    end
    --If key doesnt exist, kick the player because its a hacker
    if not Functions[key] then
        Player():Kick()
        return
    end

    --Log ping
    Player.LastPing = tick()

    --Execute function
    Functions[key](Player,Message)
end)

return Network