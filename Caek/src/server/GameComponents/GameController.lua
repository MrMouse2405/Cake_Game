--Class
local GameController = {}
GameController.__index = GameController

--Modules
local CakeEnums = require(script.Parent:FindFirstChild("CakeComponents"):FindFirstChild("CakeEnums"))
local Cake      = require(script.Parent:FindFirstChild("CakeComponents"):FindFirstChild("Cake"))

local NetworkModule = require(script.Parent:FindFirstChild("NetworkModule"))

local MachineController = require(script.Parent:FindFirstChild("KitchenComponents"):FindFirstChild("MachineController"))
local PlayerManager = require(script.Parent:FindFirstChild("PlayerManager")).new(NetworkModule)
local OrderSystem   = require(script.Parent:FindFirstChild("OrderComponents"):FindFirstChild("OrderSystem"))

--Constructor
function GameController.new(Model)
    MachineController = MachineController.new(Model,Cake,CakeEnums,PlayerManager,OrderSystem)
    MachineController:Init()
    OrderSystem = OrderSystem.new(Model:FindFirstChild("OrderScreen"))
end

return GameController