--[[

function Player:HasRecievedOrder()

function Player:GiveOrder(OrderSheet)
   
function Player:HasTray()
function Player:GiveTray(Tray)
function Player:GetTray()

function Player:HasCake()
function Player:AddCake(Cake)
function Player:GetCake()

function Player:HasBakedCake()
function Player:BakeCake()

function Player:AddDisplayCake(Cake)
function Player:DisplayCakeDetails(string)

function Player:Notify(key,string)

function Player:Reset()
function Player:Delete()

]]


--Class
local Player = {}
Player.__index = Player

--Vars
local Storage = game:GetService("ReplicatedStorage"):FindFirstChild("Storage")
local NetworkModule

--Constructor
function Player.new(plr)
    
    local self = {}
    setmetatable(self,Player)

    self.plr         = plr
    self.Cake        = nil
    self.DisplayCake = nil
    self.Tray        = nil
    self.Order       = nil
    self.CakeBaked   = nil

    --//Client Side Assets
    self.Client      = Storage:FindFirstChild("Client"):Clone()
    self.CakeGUIs    = {}
    
    --//Tracking
    self.Refresh     = false
    self.LastPing    = tick()

    --//Selectors
    self.BaseFlavour          = "Vanilla"
    self.IcingColour          = "Vanilla"
    self.IcingToppingsFlavour = "Vanilla"

    --// Score
    self.Score = 0

    --//Basic Setup
    self.Client.Parent = plr:FindFirstChild("PlayerGui")

    return self
end

--Methods

--To directly get player
Player.__call = function(player)
    return player.plr
end

-- Score / Points
function Player:IncrementScore()
    self.Score = self.Score + 5
end

--Order
function Player:HasRecievedOrder()
    return self.Order ~= nil
end

function Player:GiveOrder(OrderSheet)
    self.Order = OrderSheet
    self:Notify("Order",OrderSheet)
end

--Tray
function Player:HasTray()
    return self.Tray ~= nil
end

function Player:GiveTray(Tray)
    self.Tray = Tray
    --//Adding to backpack
    Tray:GetTool().Parent = self():FindFirstChild("Backpack")
    --//Making Player Equip
    self().Character:FindFirstChild("Humanoid"):UnequipTools()
    self().Character:FindFirstChild("Humanoid"):EquipTool(Tray:GetTool())
end

function Player:GetTray()
    return self.Tray
end

--Cake
function Player:HasCake()
    return self.Cake ~= nil
end

function Player:AddCake(Cake)
    self.Cake = Cake
end

function Player:GetCake()
    return self.Cake
end

--Cake Baked
function Player:HasBakedCake()
    return self.CakeBaked ~= nil
end

function Player:BakeCake()
    self.CakeBaked = true
end

--Display Cake
function Player:AddDisplayCake(Cake)
    self.DisplayCake = Cake
end

--Notification
function Player:Notify(Key,Str)
    NetworkModule.postMessage(self(),Key,Str)
end

--New Cake
function Player:Reset()
    self.DisplayCake:Delete()
    self.Cake:Delete()
    self.Tray:Delete()
end

--Deleting Player
function Player:Delete()

    self:Reset()

    self.Order = nil

    setmetatable(self,{__mode = "kv"})
    self = nil
end

return function (networkModule)
    NetworkModule = networkModule
    return Player
end