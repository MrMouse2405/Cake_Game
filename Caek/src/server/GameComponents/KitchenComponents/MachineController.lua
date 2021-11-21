--Class
local MachineController = {}
MachineController.__index = MachineController

--Messages
local Messages = require(script.Parent:FindFirstChild("Messages"))

--Constructor
function MachineController.new(Model,Cake,CakeEnums,PlayerManager,OrderSystem)
    
    local self = {}
    setmetatable(self,MachineController)

    self.Model         = Model
    self.GameStructure = nil
    self.Cake          = Cake
    self.CakeEnums     = CakeEnums
    self.PlayerManager = PlayerManager
    self.Machines = require(script.Parent:FindFirstChild("Machines")).new(self.PlayerManager,Messages,OrderSystem,CakeEnums,Cake)
    
    return self
end

--Game Structure
local getGameStructure = function(Machines,Model,CakeEnums)

    local gameStructure = {
        ["Order"]        = Machines.Order;
        ["Trays"]        = Machines.Tray;
        ["Bases"]        = Machines.Bases;
        ["Oven"]         = Machines.Oven;
        ["Icing"]        = Machines.Icing;
        ["IcingTopping"] = Machines.IcingToppings;
        ["Toppings"]     = Machines.Toppings;
        ["Sprinkles"]    = Machines.Sprinkles;
        ["Selector"]     = Machines.Selector;
        ["Delivery"]     = Machines.Delivery;
    }

    --//Bases
    for _,x in pairs(Model:FindFirstChild("Base"):FindFirstChild("Interactables"):GetChildren()) do
        gameStructure[x.Name] = nil
    end

    --//Toppings
    for _,x in pairs(Model:FindFirstChild("Toppings"):FindFirstChild("Toppings"):GetChildren()) do
        gameStructure[x.Name] = nil
    end
    
    return gameStructure
end


--Methods
function MachineController:Init()

    self.GameStructure = getGameStructure(self.Machines,self.Model)
    
    for _,x in pairs(self.Model:GetDescendants()) do
        if x:IsA("ProximityPrompt") then
            self:SetUpProximityPrompts(x)
        end
    end

   getGameStructure = nil

end

function MachineController:SetUpProximityPrompts(prompt)

    if self.GameStructure[prompt.Parent.Parent.Name] then
        self.GameStructure[prompt.Parent.Parent.Name](prompt)
        
    --//For Complex Names, such as Bases (Bases:Hexagon, Bases:Square), we need to make sure they all use Bases Function ONLY    
    elseif string.find(prompt.Parent.Parent.Name,":") and (self.GameStructure[string.split(prompt.Parent.Parent.Name,":")[1]]) then
        self.GameStructure[string.split(prompt.Parent.Parent.Name,":")[1]](prompt)
    end
    
end

return MachineController