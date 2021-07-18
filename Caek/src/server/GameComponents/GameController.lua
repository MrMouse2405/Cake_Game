--Class
local GameController = {}
GameController.__index = GameController

--Modules
local CakeEnums = require(script.Parent:FindFirstChild("CakeComponents"):FindFirstChild("CakeEnums"))
local Cake      = require(script.Parent:FindFirstChild("CakeComponents"):FindFirstChild("Cake"))

local MachineController = require(script.Parent:FindFirstChild("KitchenComponents"):FindFirstChild("MachineController"))
local PlayerManager = require(script.Parent:FindFirstChild("PlayerManager")).new()
local OrderSystem   = require(script.Parent:FindFirstChild("OrderComponents"):FindFirstChild("OrderSystem")).new()  

--Constructor
function GameController.new(Model)
    MachineController = MachineController.new(Model,Cake,CakeEnums,PlayerManager,OrderSystem)
    MachineController:Init()
end

return GameController