--[[

function OrderDisplayer:AddInList(model)
function OrderDisplayer:RemoveInList(model)

function OrderDisplayer:RefreshDisplays()

]]

local OrderDisplayer = {}

-- Order Screen to display UI.
local UIs = {}
local Que = {}
local ThreadRunning = false
local Size = 0

-- Folder For Cakes
local DisplayerFolder = game:GetService("ReplicatedStorage"):WaitForChild("DisplayerFolder")


-- Initializing UIs
do

    local UI
    local OrderScreens = workspace:WaitForChild("Caek"):WaitForChild("OrderScreen")
    
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Running 8 Times and creating surfce guis with view port frames, and then setting adornee to the order screen
    for i = 1,8,1 do
        
        local SUI = Instance.new("SurfaceGui")
        SUI.Face  = Enum.NormalId.Right
        SUI.ResetOnSpawn = false
        
        local VUI = Instance.new("ViewportFrame",SUI)
        VUI.BackgroundColor3 = Color3.fromRGB(71, 64, 65)
        VUI.Size = UDim2.fromScale(1,1)
    

        local Camera = Instance.new("Camera",VUI)
        Camera.CFrame = CFrame.new(Vector3.new(-5,5,5),Vector3.new(0,0,0))
        Camera.FieldOfView = 40

        VUI.CurrentCamera = Camera

        local WorldModel  = Instance.new("WorldModel")
        WorldModel.Parent = VUI

        SUI.Name   = tostring(i)
        SUI.Adornee = OrderScreens:WaitForChild("OrderScreen:"..tostring(i))

        SUI.Parent = PlayerGui

        table.insert(UIs,SUI)
        Size = Size + 1
    end
end

local function AddToDisplayer(Cake)
    local TargetUI = UIs[tonumber(Cake.Name)]

    repeat
        task.wait(2)
    until Cake.PrimaryPart

    -- 3.1415926535898 in radians means 180 degrees in angles
    Cake:SetPrimaryPartCFrame(CFrame.new())-- * CFrame.Angles(3.1415926535898,0,0))   
    Cake.Parent = TargetUI.ViewportFrame.WorldModel
end

local function IsQueEmpty()
    return #Que == 0
end

local function EmptyQue()
    ThreadRunning = true
    while next(Que) do
        AddToDisplayer(Que[1])
        table.remove(Que,1)
    end
    ThreadRunning = false
end

local Processing = false

local function Add(Cake)

    repeat
        task.wait()
    until not Processing

    Processing = true

    table.insert(Que,Cake)
    
    if not IsQueEmpty() and not ThreadRunning then
        task.spawn(EmptyQue)
    end

    Processing = false

end

function OrderDisplayer.Remove(num)
    for _,x in pairs(UIs[tonumber(num)].ViewportFrame.WorldModel:GetChildren()) do
        x:Destroy()
    end
end

for _,x in pairs(DisplayerFolder:GetChildren()) do
    Add(x)
end

DisplayerFolder.ChildAdded:Connect(Add)

for _,x in pairs(DisplayerFolder:GetChildren()) do
    AddToDisplayer(x)
end

return OrderDisplayer