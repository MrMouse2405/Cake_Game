--[[

    Cake Engine.

    Takes care of all client side visuals and effects.

]]

-- Caching --------------------------------
-- NetworkService
local NetworkService = require(script.Parent:FindFirstChild("NetworkModule"))
-- Cake Displayer
local OrderDisplayer = require(script.Parent:FindFirstChild("OrderDisplayer"))


-- CakeUI
local CakeUI  = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CakeClient")
local Details = CakeUI:WaitForChild("Details")
local Score   = CakeUI:WaitForChild("Score")
local Notifier = CakeUI:WaitForChild("Notifier")

local NormalColour  = Color3.fromRGB(255,255,255)
local CorrectColour = Color3.fromRGB(0,255,0)
local WrongColour   = Color3.fromRGB(164, 28, 28)

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

-- To avoid printing messages for ever lol. 
local function IsQueSizeMax()
    return #Queue > 2
end 

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

local processing = false

NetworkService:BindToServerMessage("Notify",function(Data)

    -- waiting until last notification request was processed
    repeat 
        task.wait()
    until not processing

    processing = true

    -- If Que size limit is reached, then drop the request
    -- this is to avoid sending notifications forever,
    -- cuz sometimes players can get floaded by notifications.
    if IsQueSizeMax() then
        processing = false
        return
    end

    -- Insert into que
    table.insert(Queue,Data)

    -- Check if Que is empty, if it isnt, then check if thread running,
    -- if thread isnt running or if its dead, then make new one and run it.
    if not IsQueEmpty() and not Running then
        print("Spawned")
        task.spawn(RunWhileQueueIsNotEmpty)
    end

    processing = false

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

-- Removing Orders ------------------------------------
NetworkService:BindToServerMessage("Remove",function(Data)
    OrderDisplayer.Remove(Data)
end)

-- Dispalying if correct or wrong, when player chooses an option
for _,x in pairs(UIs) do
    NetworkService:BindToServerMessage(x,function(Data)
        
        local Color = (function()
            if Data then
                return CorrectColour
            end
            return WrongColour
        end)()
        
        Details:WaitForChild(x).TextColor3 = Color 
        local ScoreUI = Score:WaitForChild(x)
        ScoreUI.TextColor3 = Color
        ScoreUI.Text = (function()
            if Data then
                return "+10"
            else
                return "+0"
            end
        end)()

    end)
end

-- Reseting Order
NetworkService:BindToServerMessage("Reset",function(Data)
    for _,x in pairs(UIs) do
        x = Details:WaitForChild(x) 
        x.TextColor3 = NormalColour
        x.Text = "---"
    end
end)

-- Silent Reset, keeps the order, removes the progress
NetworkService:BindToServerMessage("SilentReset",function(Data)
    for _,x in pairs(UIs) do
        x = Details:WaitForChild(x)
        x.TextColor3 = NormalColour
    end
end)

NetworkService:BindToServerMessage("ShowScore",function(Data)
    Score:WaitForChild("Total").Text = "+"..Data
    Score.Visible = true
end)

return function()

end
