--Class
local Tray = {}
Tray.__index = Tray

--Assets
local tray = game:GetService("ReplicatedStorage"):FindFirstChild("Storage"):FindFirstChild("Tray")

--Constructor
function Tray.new()
    local self = {}
    setmetatable(self,Tray)
    self.Tray = tray:Clone()
    return self
end

--When Table is called, it returns tray handle directly
Tray.__call = function(tray)
    return tray.Tray:FindFirstChild("Handle")
end


--Methods
function Tray:AddCake(Cake)

    Cake:GetModel():SetPrimaryPartCFrame(
        self().CFrame +
        Vector3.new(
            0,
            (self().Size.Y/2) + (Cake().Size.Y/2),
            0
        )
    )
    
    --Welding
    local w = Instance.new("WeldConstraint",self.Tray.Handle)
    w.Part0 = self()
    w.Part1 = Cake()
    
    --Now Parenting to tool
    Cake:GetModel().Parent = self:GetTool()
end

function Tray:GetTool()
    return self.Tray
end

function Tray:IsEquipped()
    return not self.Tray.Parent:IsA("Backpack")
end

function Tray:Delete()
    self:GetTool():Destroy()
    setmetatable(self,{__mode = "kv"})
    self = nil
end


return Tray