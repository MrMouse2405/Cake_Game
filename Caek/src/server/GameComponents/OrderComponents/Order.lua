--[[

    function OrderSystem.new()
    
    function OrderSystem:CreateNewOrder() --> OrderSheet

    function OrderSystem:GetCakeFromOrderSheet(OrderSheet)

    function OrderSystem:GetClientEncodedData(OrderSheet)
]]

--Class
local OrderSystem = {}
OrderSystem.__index = OrderSystem

--Variables
local CakeEnums = require(script.Parent.Parent:FindFirstChild("CakeComponents"):FindFirstChild("CakeEnums"))
local Cake      = require(script.Parent.Parent:FindFirstChild("CakeComponents"):FindFirstChild("Cake"))

--utils

--//To count, table.getn or # doesnt work on Dictionaries
local function getn(Table)

    local count = 0

    for _,_ in pairs(Table) do
        count += 1;
    end

    return count

end

--//Find the element at provided index in number 
local function findn(Table, number)
    
    local count = 1

    for _,x in pairs(Table) do
        if count == number then
            return x
        end
        count += 1;
    end

end

local function findi(Table, value)
    for x,_ in pairs(Table) do
        if Table[x] == value then
            return x
        end
    end
end

--//Gets the Flavour Index, currently we are storing order Index
local function getIndexName(Table, Value)
    for Name, value in pairs(Table) do
        if value == Value then
            return Name
        end
    end
end

--Constructor
function OrderSystem.new()
    local self = {}
    setmetatable(self,OrderSystem)
    return self
end

--Order Sheet
local OrderSheet = {
    Base                 = nil;
    BaseFlavour          = nil;
    Icing                = nil;
    IcingColour          = nil;
    Sprinkles            = nil;
    IcingToppings        = nil;
    IcingToppingsFlavour = nil;
    CakeToppings         = nil;
    DropOff              = nil;
    Cake                 = nil;
}

--Methods
function OrderSystem:CreateNewOrder()
    
    local NewOrder = OrderSheet

    --For making it randomized even better
    math.randomseed(tick())

    --Adding random ingredients
    
    --Base,Icing And icing toppings are always same
    NewOrder.Base          = findn(CakeEnums.Bases,math.random(1, getn(CakeEnums.Bases))) 
    NewOrder.Icing         = CakeEnums.Icings[NewOrder.Base.Name]
    NewOrder.IcingToppings = CakeEnums.IcingToppings[NewOrder.Base.Name]
    
    --Flavours can be randomized, base flavour and icing toppings flavour use same colour codes
    NewOrder.BaseFlavour          = findi(CakeEnums.BaseFlavours,findn(CakeEnums.BaseFlavours, math.random(1,getn(CakeEnums.BaseFlavours))))
    NewOrder.IcingColour          = findi(CakeEnums.IcingColour,findn(CakeEnums.IcingColour,  math.random(1,getn(CakeEnums.IcingColour ))))
    NewOrder.IcingToppingsFlavour = findi(CakeEnums.BaseFlavours,findn(CakeEnums.BaseFlavours, math.random(1,getn(CakeEnums.BaseFlavours))))

    --Sprinkles and CakeToppings can be randomized
    NewOrder.Sprinkles    = findn(CakeEnums.Sprinkles[NewOrder.Base.Name],math.random(1,getn(CakeEnums.Sprinkles[NewOrder.Base.Name])))
    NewOrder.CakeToppings = findn(CakeEnums.CakeToppings,math.random(1,getn(CakeEnums.CakeToppings)))

    --Drop off location
    NewOrder.DropOff = math.random(1,10)

    --Visual Cake
    NewOrder.Cake = self:GetCakeFromOrderSheet(NewOrder)
    return NewOrder
end

function OrderSystem:GetCakeFromOrderSheet(OrderSheet)
   
    --Creating our Cake
    local cake = Cake.new()
    
    --Base
    cake:ApplyBase(OrderSheet.Base)
    cake:ApplyBaseFlavour(CakeEnums.BaseFlavours[OrderSheet.BaseFlavour])

    --Icing
    cake:ApplyIcing(OrderSheet.Icing)
    cake:ApplyIcingColour(CakeEnums.IcingColour[OrderSheet.IcingColour])
    
    --IcingToppings
    cake:ApplyIcingToppings(OrderSheet.IcingToppings)
    cake:ApplyIcingToppingsFlavour(CakeEnums.BaseFlavours[OrderSheet.IcingToppingsFlavour])
    
    --Sprinkles
    cake:ApplySprinkles(OrderSheet.Sprinkles)

    --Cake Toppings
    cake:ApplyCakeToppings(OrderSheet.CakeToppings)
    
    return cake
end

function OrderSystem:GetClientEncodedData(OrderSheet)
    return {
        OrderSheet.Base.Name,            -- Base [1]
        OrderSheet.BaseFlavour,          -- Base Flavour [2]
        OrderSheet.IcingColour,          -- Icing Colour [3]
        OrderSheet.Sprinkles.Name,       -- Sprinkles [4]
        OrderSheet.IcingToppingsFlavour, -- IcingToppingsFlavour [5]
        OrderSheet.CakeToppings.Name,    -- Cake Toppings [6]
        "N/A"                            -- Delivery [7]  
    }
end

return OrderSystem