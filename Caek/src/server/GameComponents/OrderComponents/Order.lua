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

local n = CakeEnums.n

print(n)

local function getRand(Index)
    print(getn(CakeEnums[Index]))
    local num = math.random(1,getn(CakeEnums[Index]))
    local x = n[Index][num]
    print(num)
    print(x)
    print(CakeEnums[Index])
    print(CakeEnums[Index][x])
    return CakeEnums[Index][x]
end

--Methods
function OrderSystem:CreateNewOrder()
    
    local NewOrder = OrderSheet

    --For making it randomized even better
    math.randomseed(tick())

    --Adding random ingredients
    
    --Base,Icing And icing toppings are always same
    NewOrder.Base          = getRand("Bases")
    NewOrder.Icing         = CakeEnums.Icings[NewOrder.Base.Name]
    NewOrder.IcingToppings = CakeEnums.IcingToppings[NewOrder.Base.Name]
    
    --Flavours can be randomized, base flavour and icing toppings flavour use same colour codes
    NewOrder.BaseFlavour          = getRand("BaseFlavours")
    NewOrder.IcingColour          = getRand("IcingColour")
    NewOrder.IcingToppingsFlavour = getRand("BaseFlavours")


    local Sprinkles = CakeEnums.Sprinkles[NewOrder.Base.Name]

    --Sprinkles and CakeToppings can be randomized
    NewOrder.Sprinkles    = Sprinkles[n.Sprinkles[NewOrder.Base.Name][math.random(1,getn(Sprinkles))]]
    NewOrder.CakeToppings = getRand("CakeToppings")

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
    cake:ApplyBaseFlavour(OrderSheet.BaseFlavour)

    --Icing
    cake:ApplyIcing(OrderSheet.Icing)
    cake:ApplyIcingColour(OrderSheet.IcingColour)
    
    --IcingToppings
    cake:ApplyIcingToppings(OrderSheet.IcingToppings)
    cake:ApplyIcingToppingsFlavour(OrderSheet.IcingToppingsFlavour)
    
    --Sprinkles
    cake:ApplySprinkles(OrderSheet.Sprinkles)

    --Cake Toppings
    cake:ApplyCakeToppings(OrderSheet.CakeToppings)
    
    return cake:GetModel()
end

function OrderSystem:GetClientEncodedData(OrderSheet)
    return {
        OrderSheet.Base.Name,            -- Base [1]
        getIndexName(CakeEnums.BaseFlavours,OrderSheet.BaseFlavour),          -- Base Flavour [2]
        getIndexName(CakeEnums.IcingColour,OrderSheet.IcingColour),          -- Icing Colour [3]
        OrderSheet.Sprinkles.Name,                                     -- Sprinkles [4]
        getIndexName(CakeEnums.BaseFlavours,OrderSheet.BaseFlavour),   -- IcingToppingsFlavour [5]
        OrderSheet.CakeToppings.Name,    -- Cake Toppings [6]
        tostring(OrderSheet.DropOff)        -- Delivery [7]
    }
end

return OrderSystem