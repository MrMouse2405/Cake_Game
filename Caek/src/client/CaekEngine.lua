--[[

    Cake Engine.

    Takes care of all client side visuals and effects.

]]

-- Caching --------------------------------
-- NetworkService
local NetworkService = require(script.Parent:FindFirstChild("NetworkModule"))
-- Cake Displayer Table.


-- CakeUI
local CakeUI  = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CakeClient")
local Details = CakeUI:WaitForChild("Details")
local Notifier = CakeUI:WaitForChild("Notifier")

-- Selectors --------------------------------
local Selectors = game:GetService("CollectionService"):GetTagged("Caek")[1]:FindFirstChild("Selector")

NetworkService:BindToServerMessage("Selector",function(Data)
    
    local Selector = Selectors[Data:sub(1,1) .. ":Selector"]

    local FlavourBefore = (function() 
        if Data:sub(2,2) == "1" then
            return "9"
        end
        return tostring(tonumber(Data:sub(2,2))-1)
    end)()

    local Flavour  = Data:sub(2,2)

    for _, flavour in pairs(Selector:GetChildren()) do
        
        local flavourIndex = flavour.Name:sub(1,1) 
        if flavourIndex == FlavourBefore then 
            FlavourBefore = flavour
            break 
        end        
    end

    for _, flavour in pairs(Selector:GetChildren()) do
        local flavourIndex = flavour.Name:sub(1,1) 
        if flavourIndex == Flavour then 
            Flavour = flavour
            break 
        end        
    end
 
    FlavourBefore.Transparency = 0.5
    Flavour.Transparency = 0

    local TextLabel = Selector.Displayer.SurfaceGui.TextLabel

    TextLabel.Text = Flavour.Name:sub(3)
    TextLabel.TextColor3 = Flavour.Color
end)


-- Notifications ---------------------------
local Queue = {}

local function IsQueEmpty()
    return #Queue == 0
end

local Running = false

local function RunWhileQueueIsNotEmpty()
    
    Running = true

    while next(Queue) do
        
        -- Get Current String
        local CurrentString = Queue[1]
        table.remove(Queue,1)
        
        -- Display current string
        local len = #CurrentString
        for i = 1,len+1, 1 do
            Notifier.Text = CurrentString:sub(1,i)
            task.wait(.03)
        end

        -- wait for a while
        task.wait(2)

        -- reset
        Notifier.Text = ""
    end

    Running = false
end


NetworkService:BindToServerMessage("Notify",function(Data)
   
    print(Data)
   
    table.insert(Queue,Data)
    print(IsQueEmpty())

    if not IsQueEmpty() and not Running then
        print("Spawned")
        task.spawn(RunWhileQueueIsNotEmpty)
    end

end)

-- Order Data ---------------------------------
local UIs = {
    "Base","BaseFlavour","Icing","Sprinkles","IcingTopping","Topping","DropOff"
}

NetworkService:BindToServerMessage("Order",function(Data)
    for i = 1,7,1 do
        Details:WaitForChild(UIs[i]).Text = Data[i]
    end
end)

-- Cake Displayer ------------------------------
NetworkService:BindToServerMessage("Cake",function(Data)
end)

return function()
end