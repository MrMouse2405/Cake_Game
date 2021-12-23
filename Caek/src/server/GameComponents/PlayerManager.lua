--Class
local PlayerManager = {}
PlayerManager.__index = PlayerManager

--Vars
local player = require(script.Parent:FindFirstChild("Player"))
local NetworkModule

--Constructor
function PlayerManager.new(networkModule)
    local self = {}
    setmetatable(self,PlayerManager)

    self.Players = {}
    self.Events  = {}

    --Initialising Network Module and passing network module reference to player object
    NetworkModule = networkModule
    NetworkModule.setPlayerManager(self)
    player = player(NetworkModule)

    --Removing Player once it leaves
    game.Players.PlayerRemoving:Connect(function(player)
        PlayerManager.RemovePlayer(self,player)
    end)

    return self
end

--Methods
function PlayerManager:FindPlayer(Player)
    return self.Players[Player]
end

function PlayerManager:AddPlayer(Player)
    
    --Creating Player Object
    Player = player.new(Player)

    --Adding to our Player Table
    self.Players[Player()] = Player

    --If Player Dies, player is removed, player would need to start over the game
    self.Events[Player()] = Player().CharacterAdded:Connect(function()
        Player:Notify("SilentReset","")
        Player:SilentReset()
    end)


end

function PlayerManager:RemovePlayer(Player)
    if self.Players[Player] then
        self.Events[Player()]:Disconnect()
        self.Players[Player]:Delete()
        self.Players[Player] = nil
        if self.Events[Player] then
            self.Events[Player]:Disconnect()
            self.Events[Player] = nil
        end
    end
end

function PlayerManager:GetAllPlayers()
    return self.Players
end

function PlayerManager:NotfiyAll(Key,Data)
    for _,x in pairs(self.Players) do
        task.spawn(function()
            x:Notify(Key,Data)
        end)
    end
end

return PlayerManager
