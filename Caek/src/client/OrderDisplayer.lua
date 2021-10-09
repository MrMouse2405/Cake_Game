--[[

function OrderDisplayer:AddInList(model)
function OrderDisplayer:RemoveInList(model)

function OrderDisplayer:RefreshDisplays()

]]

--Vars
local PlayerManager
local GUIs = {}


--Functions
local function Display(Screen,Cake)
    Cake:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,0,0)))
    Screen:FindFirstChild("SG"):FindFirstChild("VP"):FindFirstChild("Cam").CFrame = CFrame.lookAt(Vector3.new(5,5,-5),Cake.PrimaryPart.Position)
    Cake.Parent = Screen:FindFirstChild("SG"):FindFirstChild("VP")
end

local function GetDisplay(model,n)
    return model:FindFirstChild("OrderScreen:"..tostring(n))
end

local function GetFromDisplay(Screen)
    return Screen:FindFirstChild("SG"):FindFirstChild("VP"):FindFirstChildWhichIsA("Model")
end

--Class For ViewPortFrames
local Screen = {}
Screen.__index = Screen

function Screen.new(screen)
    
    local self = {}
    setmetatable(self,Screen)

    --//Creating Our Gui
    local SG      = Instance.new("SurfaceGui")
    local VP      = Instance.new("ViewportFrame",SG)
    local Cam     = Instance.new("Camera",VP)
    VP.CurrentCamera = Cam
            
    SG.Name     = "SG"
    VP.Name     = "VP"
    Cam.Name    = "Cam"

    --//Surface GUI Design
    SG.Face    = Enum.NormalId.Top
    SG.Adornee = screen
        
    --//Viewport Design
    VP.CurrentCamera = Cam

    VP.Size = UDim2.fromScale(1,1)
    VP.BackgroundTransparency = 0

    self.Gui      = SG
    self.ViewPort = VP
    self.Copies   = {}

    return self
end

function Screen:RefreshAll()
    for _,x in pairs(self.Copies) do
         
    end   
end

--Class
local OrderDisplayer = {}
OrderDisplayer.__index = OrderDisplayer

--Constructor
function OrderDisplayer.new(Model)
    
    local self = {}
    setmetatable(self,OrderDisplayer)

    self.Model = Model
    self.CakeList = {}
    self.Occupied = 0

    --//Init
    for _,x in pairs(Model:GetChildren()) do
        if string.sub(x.Name,1,11) == "OrderScreen" then
            table.insert(GUIs,tonumber(x.Name:sub(-1,-1)),Screen.new(x))
        end
    end

    return self
end

--Methods
function OrderDisplayer:AddInList(model)
    table.insert(self.CakeList,model)
end

function OrderDisplayer:RemoveInList(model)
    local CakeIndex = table.find(self.CakeList,model)
    table.remove(self.CakeList,CakeIndex)
    return GetFromDisplay(GetDisplay(self.Model,CakeIndex))
end

function OrderDisplayer:RefreshDisplays()
    print(self.CakeList)
    table.foreach(self.CakeList,function(index,cake)
        Display(GetDisplay(self.Model,index),cake)
    end)
end

return OrderDisplayer