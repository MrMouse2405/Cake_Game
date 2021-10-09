--[[

    function OrderSystem.new()
    function OrderSystem:GetOrder()

]]


--Modules
local Order     = require(script.Parent:FindFirstChild("Order")).new()
local Displayer = require(script.Parent:FindFirstChild("OrderDisplayer"))


--Vars
local OrderList = {}


--Functions
local function AddNewOrder(Order)
    table.insert(OrderList,Order)
    --Displayer:AddInList(Order.Cake:GetModel())
    --Displayer:RefreshDisplays()
end

local function RemoveOrder()
    local order = OrderList[1]
    table.remove(OrderList,1)
    --Displayer:RemoveInList(order.Cake)
    return Order:GetClientEncodedData(order)
end

local function ReconcileOrderList()
    while task.wait(math.random(0,10)) do
        if #OrderList == 8 then return end
        math.randomseed(tick())
        AddNewOrder(Order:CreateNewOrder())
    end
end

--Class
local OrderSystem = {}
OrderSystem.__index = OrderSystem

--Constructor
function OrderSystem.new(displayer)
    
    local self = {}
    setmetatable(self,OrderSystem)

    --Displayer = Displayer.new(displayer)

    coroutine.wrap(ReconcileOrderList)()

    return self
end

--Methods
function OrderSystem:GetOrder()
    return RemoveOrder()
end

return OrderSystem